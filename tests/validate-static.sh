#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)"
terraform_bin="${TERRAFORM_BIN:-terraform}"
validation_dir="$(mktemp -d "${TMPDIR:-/tmp}/cpp-function-validate.XXXXXX")"
trap 'rm -rf "$validation_dir"' EXIT

git -C "$repo_root" ls-files --cached --others --exclude-standard -z |
  tar -C "$repo_root" --null -T - -cf - |
  tar -C "$validation_dir" -xf -

module_dirs=()
while IFS= read -r module_dir; do
  module_dirs+=("$module_dir")
done < <(find "$validation_dir" -type f -name '*.tf' -exec dirname {} \; | sort -u)

validate_module() {
  printf 'Validating %s\n' "${1#"$validation_dir"}"
  "$terraform_bin" -chdir="$1" init -backend=false -input=false -no-color
  "$terraform_bin" -chdir="$1" validate -no-color
}

cp "$validation_dir/tests/fixtures/providers/main.tf" "$validation_dir/ci_provider_override.tf"
validate_module "$validation_dir"
rm "$validation_dir/ci_provider_override.tf"

for module_dir in "${module_dirs[@]}"; do
  if [[ "$module_dir" != "$validation_dir" ]]; then
    validate_module "$module_dir"
  fi
done
