# DTSPO-35680: FTP Module Inventory and Review Evidence

Evidence date: 2026-10-26. This is the cross-repository inventory deliverable for
DTSPO-35680, not certification of deployed Azure state. Keep the module feature
branches unmerged for the remaining adoption tickets, as acceptance criterion 6
requires. Nothing in this report authorizes a merge, deployment or caller change.

## Search Coverage

The local Terraform-source scan found seven reusable definitions containing nine
relevant resource declarations. All six named candidates are included. Another
22 local declarations are direct environment resources, including duplicate
automation checkouts. Declaration counts are not deployed-resource counts.

Read-only HMCTS organization code searches covered these AzureRM resource
families: `function_app`, `linux_function_app`, `windows_function_app`,
`function_app_flex_consumption`, `app_service`, `linux_web_app`,
`windows_web_app` and `logic_app_standard`. Searches used the exact resource-type
identifier with `language:HCL`, with up to 100 results per query, and separate
module-source searches. Every additional resource-bearing repository returned
by those searches is assessed below. No Flex Consumption hit was returned.

Additional `archived:true` searches for legacy Function Apps, App Services and
Logic Apps Standard returned no hits. This does not prove that inaccessible,
unindexed or non-default-branch code does not exist. The search tool provides
excerpts, not an authoritative organization-wide repository enumeration or a
pagination-completeness certificate. No local `.tf.json` source was found.

Consumer references establish source usage, not a successful current deployment.
An absent reference or old commit is not proof of retirement. No module is
excluded merely because its operational lifecycle is uncertain.

## Module Inventory

Definitions and consumer evidence URLs are listed in the source index below.

| Module | Resource Types | Contract on Prepared Branch | Source Lifecycle Assessment |
| --- | --- | --- | --- |
| CPP Function App | Linux and Windows Function Apps | Existing nested input validates only Disabled/FtpsOnly. Missing/null maps to Disabled. Both resources explicitly receive the value. | Active source usage: two external consumer repositories. |
| Crime IDAM PaaS Function App | Legacy Function App | New validated input, missing/null Disabled, explicit resource mapping. | Active source configuration: live and non-live environment callers remain present. |
| DLRM Function App | Linux Function App | Validated input, missing/null Disabled, explicit resource mapping. | Active source configuration: landing consumer and sbox enablement. |
| CNP Web App | Linux and Windows Web Apps | Validated input, missing/null Disabled, explicit resource mapping. | Retained and tested module. No non-test consumer identified in the accessible search. Operational active/migration/historical classification needs reviewer acceptance or correction. |
| MI Logic App Standard | Logic App Standard | Existing fixed FtpsOnly, no FTP input or caller override. Production Terraform unchanged. | Active source configuration: notification Logic App caller and environment deployment pipeline. |
| DLRM IP Kit Logic App | Logic App Standard | Validated input, missing/null Disabled, explicit resource mapping. | Active source configuration: landing consumer for all configured landing zones. |
| ARIA Function App | Linux Function App | Original caller pins AzureRM 4.1.0, whose implementation defaults the omitted field to Disabled. No source FTP override. | Retained migration-project source, with sandbox caller. Actual active/migration/historical status needs reviewer acceptance or correction. No production FTP repair demonstrated under the known provider pin. |

"Active source configuration" describes the checked configuration, not observed
deployment activity. "Retained" is a conservative inventory disposition, not
evidence that an owner has scheduled a migration. No historical classification
is asserted without retirement evidence.

## Consumers and Environment Coverage

| Module | Identified Consumers | Environment/Tenancy Evidence and Limits |
| --- | --- | --- |
| CPP Function App | `hmcts/cpp-terraform-functionapp-deployment` and `hmcts/cpp-terraform-azurerm-graphhourlyusage` | Both reference floating `main`. Deployment configuration includes PRD and non-live DEV/SIT/NFT/STE source files. Some STE hearingres files explicitly create no PaaS Function Apps. Graph-hourly configuration includes MDV/MPD. CPP Live/Nonlive coverage is source-based, not tenant authentication or deployed-state certification. |
| Crime IDAM Function App | PaaS environments under live BAE/PRD/PRP/PRX and non-live DEV/NFT/SIT/STE, plus a provisioning test fixture | Local scan found 39 environment module calls in 36 files, plus the separate test call. Counts include two calls in some SCSL files. The live/non-live source organization establishes CPP environment coverage, not actual selected runner versions or deployment activity. |
| DLRM Function App | Landing component's `function_app` module call | Uses `deploy_function_app`, default false. Only sbox explicitly enables it in the checked environment files. The pipeline includes sbox/stg/prod landing stages, which alone do not imply Function Apps are created in every stage. |
| DLRM IP Kit Logic App | Landing component's `logic` module call | Iterates all landing zones without the Function App enablement filter. Pipeline names sbox/stg/prod landing stages and DTS-DATAINGEST connections. Provider aliases include CNP subscriptions. This is CNP/SDS source context, not a verified Entra tenant identity. |
| CNP Web App | Module-native tests, `hmcts/terraform-utils` whitelist fixtures and Jenkins approval-policy references | Fixtures and allowlists are not production consumers. Courtstranscribe explicitly uses direct resources instead. CNP's module-test pipeline uses DTS-SHAREDSERVICES-TEST. The knowledge-store adoption report independently records no module callers at the assessed baseline. No actual production consumer was established. |
| MI Logic App | Notification Logic App root | Pipeline declares SBOX/DEV/TEST/ITHC/STG/PROD and DTS-SHAREDSERVICES connections. The static service-connection catalog groups shared-services subscriptions with CNP restoration access. This is source-level CNP/shared-services context, not proof of current deployment activity. |
| ARIA Function App | Sandbox Terraform root's `AzureFunctions` module call | Source belongs to the ARIA Migration project. Caller pins AzureRM 4.1.0 but has empty subscription/tenant fields. Reviewed pipelines build/sync Databricks content rather than establishing Function App Terraform deployment activity. Do not infer retirement or tenant membership from this. |

Public metadata on the evidence date reports CNP Web App and ARIA as neither
archived nor disabled. Metadata and push dates do not establish production use.

An unfiltered CNP reference search also found `cnp-jenkins-config` approval
entries for IDAM API, IDAM Web Public, Ethos Docmosis and Plum infrastructure,
including historical or modernization branch refs. These are adoption leads,
not proof those projects currently instantiate the module. The indexed
`cnp-knowledge-store` adoption report says the module has no callers and is
named only in Jenkins config/library. Its provenance record identifies the
same `71e7184b85beb8347411a01a2fbf694834345ef0` baseline assessed here. This is
corroborating snapshot evidence, not an owner retirement decision. A raw request
for the knowledge-store relationship record returned 404, so its full JSON
contents were not independently retrieved. The local deprecation map and
runbooks yielded no explicit CNP/ARIA retirement or migration decision.

## Additional Resource Candidates: Root-Level Exclusions

These are assessed, not silently omitted. Backend evidence beside the resource
declarations supports treating them as independently deployed Terraform roots,
not reusable child-module definitions. No FTP compliance claim is made for them.
Direct-resource remediation belongs to the applicable follow-up work.

| Repository | Resource-Bearing Root | Classification Evidence |
| --- | --- | --- |
| `hmcts/cpp-automation-terraform` | Non-live CCM environment roots | Direct environment resources, explicitly distinguished from modules in the ticket. |
| `hmcts/crime-idam-automation-terraform` | Non-live CCM environment roots | Direct environment resources, explicitly distinguished from modules in the ticket. |
| `hmcts/cactus-app` | Function App, Logic App, App Service and SMB relay components | Each component declares its own AzureRM backend in its provider file. |
| `hmcts/dlrm-data-ingest-aria` | ARIA-layer component | AzureRM backend in component initialization file. |
| `hmcts/semarchy-xdm` | Core component | AzureRM backend in core provider file. |
| `hmcts/juror-er-infra` | Data-factory component | AzureRM backend in component initialization file. |
| `hmcts/cveinfo-function` | CVE-info component | AzureRM backend in component provider file. |
| `hmcts/azure-alert-to-slack-function` | Infra component | AzureRM backend in component provider file. |
| `hmcts/azure-enterprise-acme` | ACME component | AzureRM backend in component provider file. |
| `hmcts/darts-shared-infrastructure` | Repository root | AzureRM backend in root state configuration. |
| `hmcts/batch-audio-transcription-infra` | Infrastructure component | Backend in main configuration, configured by shared pipeline templates. |
| `hmcts/courtstranscribe` | Infrastructure component | Infrastructure documentation describes make-driven init/plan/apply and separate app/platform remote-state keys. Its public tree API returned 404, so this classification uses indexed source documentation rather than a retrieved tree. |
| `hmcts/dts-legacy-cactus-poc` | Terraform root | Explicit AzureRM backend configuration for the PoC. |

Additional local direct declarations exist in the automation checkout alias,
Crime's copied IaaS environments and Crime's live/non-live feature-toggle roots.
They are not additional reusable module definitions. Copied paths and PoC names
are not independently treated as proof of retirement.

## Test Evidence

| Module | Terraform Runner | AzureRM | Passing Plan-Only Runs |
| --- | --- | --- | --- |
| CPP Function App | 1.16.1 | 4.18.0 | 33 |
| CPP Function App | 1.16.1 | 3.103.1 | 33 |
| Crime IDAM Function App | 1.16.1 x86 | 1.40.0 | 12 |
| DLRM Function App | 1.16.1 | 4.81.0 | 12 |
| DLRM IP Kit Logic App | 1.16.1 | 4.81.0 | 12 |
| CNP Web App | 1.16.1 | 4.81.0 | 38 |
| MI Logic App | 1.16.1 | 3.116.0 | 3 |

The six named modules have 143 passing runs across seven provider combinations.
Counts include provider fixtures and existing regressions, not 143 FTP-specific
cases. No deployment root was planned. Checks use mocked providers and dummy
values, with no Azure credentials, existing state, apply or destroy.

The second CPP run uses the unchanged suite in an isolated export with only the
test fixture's provider pin changed from 4.18.0 to 3.103.1. This matches the
graph-hourly consumer's provider file and lockfile. Both providers pass all 33
runs. The real module fixture remains pinned to the primary consumer's 4.18.0.

Crime also initializes and validates with exact Terraform 0.13.0 and AzureRM
1.40.0 in an isolated copy. Its module declares Terraform >=0.13 and AzureRM
>=1.40,<2.0. This is a documented compatibility boundary, not an upgrade to any
deployment root. Previously selected Crime versions remain adoption evidence.

ARIA's optional existing branch has 12 passing explicit-contract runs, excluded
from the named-module total. A mock of the original module returned null for
the omitted optional field and did not prove the provider default. The actual
AzureRM 4.1.0 implementation sets the schema default to `FtpsStateDisabled`.
Do not turn the failed diagnostic probe into a claimed passing baseline test.

## Adoption Handoff, Not Current-Ticket Deployment Work

- CPP's known PRD `ccm01-notifyatt` value of AllAllowed will be rejected and needs
  a coordinated caller correction. Both known CPP consumers float on main, so
  keeping these branches unmerged matters. Actual publishing requirements are
  for adoption tickets, not inferred from ZIP/package deployment settings.
- DLRM and Crime callers do not automatically gain forwarding for an FTPS
  exception. Any approved exception needs a separate caller change.
- MI retains fixed FtpsOnly. Its PR is regression coverage and documentation,
  not a production security repair.
- ARIA's existing optional local hardening commit stays untouched. No additional
  production remediation PR is justified by the known pinned default alone.
- Remote CI/deployment results and effective Azure configurations are not
  certified by mocked module checks. Do not run live provisioning tests to
  satisfy this module-contract ticket.

## Review and Closure

Acceptance criteria 2-5 have implementation, resource-level test and module
documentation evidence for all six named modules. The original ARIA path is
assessed separately through its pinned provider's secure default.

For criterion 1, review this inventory's coverage, root-level exclusions and
source-based lifecycle assessments. In particular, accept or correct the
conservative CNP and ARIA dispositions. No current production consumer or owner
migration/retirement decision was recoverable for those modules. This report
does not falsely mark that operational evidence as confirmed. An exhaustive
claim covering inaccessible/unindexed repositories also needs reviewer acceptance
of the stated search coverage or an authoritative repository list.

For criterion 6, publish the remaining local branches through the authorized
delivery route and leave every module branch unmerged. CPP, DLRM and CNP were
previously pushed. Crime is local-only. MI's push was denied repository write
access. No push was attempted during this investigation.

Code approval alone is not a substitute for inventory acceptance. Once reviewers
accept the inventory/classifications, the contracts and tests, and the branches
are available for the remaining tickets, closure does not require merge or
deployment. If reviewers cannot confirm the classification/coverage items,
criterion 1 remains open rather than being silently waived.

## Source Index

The following URLs identify the reviewed source locations. Default-branch URLs
are navigation aids, not immutable proof of future contents. Local snapshots
used for the named module branches were CPP `3d89c12`, Crime `1c82e85`,
DLRM `8f5c100`, CNP `71e7184`, MI `ab3fb75` and ARIA `56a3726` before the
prepared FTP commits. Remote-only evidence is dated indexed-source evidence,
not a claim that it was fetched at those local revisions.

- CPP definition: [main.tf](../main.tf).
- Crime definition: `https://github.com/hmcts/crime-idam-automation-terraform-paas/blob/main/paas/modules/paas_function_app/main.tf`.
- DLRM Function definition: `https://github.com/hmcts/dlrm-data-ingest-infra/blob/main/modules/function_app/function-app.tf`.
- DLRM Logic definition: `https://github.com/hmcts/dlrm-data-ingest-infra/blob/main/modules/ipkit_logic/logic-app.tf`.
- CNP definition: `https://github.com/hmcts/cnp-module-webapp/blob/master/webapp.tf`.
- MI definition: `https://github.com/hmcts/mi-logic-apps/blob/master/terraform/modules/tfm-azure-logic-app/20-main.tf`.
- ARIA definition: `https://github.com/hmcts/ARIA-Infrastructure/blob/master/01-Sandbox/Terraform/Modules/AzureFunctions/main.tf`.
- CPP deployment consumer: `https://github.com/hmcts/cpp-terraform-functionapp-deployment/blob/main/main.tf`.
- CPP graph-hourly consumer/provider: `https://github.com/hmcts/cpp-terraform-azurerm-graphhourlyusage/blob/main/main.tf` and `https://github.com/hmcts/cpp-terraform-azurerm-graphhourlyusage/blob/main/provider.tf`.
- Crime consumers: `https://github.com/hmcts/crime-idam-automation-terraform-paas/tree/main/paas/environments`.
- DLRM callers: `https://github.com/hmcts/dlrm-data-ingest-infra/tree/main/components/landing`.
- DLRM pipeline: `https://github.com/hmcts/dlrm-data-ingest-infra/blob/main/azure-pipelines.yaml`.
- MI caller/pipeline: `https://github.com/hmcts/mi-logic-apps/blob/master/terraform/logic-apps/30-notification-logic-app.tf` and `https://github.com/hmcts/mi-logic-apps/blob/master/azure-pipelines-infrastructure.yml`.
- CNP CI: `https://github.com/hmcts/cnp-module-webapp/blob/master/azure-pipelines.yml`.
- CNP fixture-only consumer: `https://github.com/hmcts/terraform-utils/tree/master/tfwhitelist/test-fixtures`.
- CNP approval references: `https://github.com/hmcts/cnp-jenkins-config/tree/master/terraform-infra-approvals`.
- CNP adoption/provenance corroboration: `https://github.com/hmcts/cnp-knowledge-store`, indexed paths `docs/module-adoption.html`, `knowledge/provenance.json` and `knowledge/relationships/by-repo/cnp-module-webapp.json`.
- ARIA caller/provider: `https://github.com/hmcts/ARIA-Infrastructure/tree/master/01-Sandbox/Terraform`.
- Provider default: `https://github.com/hashicorp/terraform-provider-azurerm/blob/v4.1.0/internal/services/appservice/helpers/function_app_schema.go`.