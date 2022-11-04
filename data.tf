data "azurerm_key_vault_secret" "main" {
  for_each     = var.application_settings_sensitive_keyvault_lookup
  name         = each.value
  key_vault_id = var.key_vault_id
}

data "vault_generic_secret" "main" {
  for_each = var.application_settings_sensitive_hashicorp_vault_lookup
  path     = each.value
}
