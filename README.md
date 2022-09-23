<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =3.19.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | =3.19.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tag_set"></a> [tag\_set](#module\_tag\_set) | git::https://github.com/hmcts/cpp-module-terraform-azurerm-tag-generator.git | main |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.app_insights](https://registry.terraform.io/providers/hashicorp/azurerm/3.19.1/docs/resources/application_insights) | resource |
| [azurerm_linux_function_app.linux_function](https://registry.terraform.io/providers/hashicorp/azurerm/3.19.1/docs/resources/linux_function_app) | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.19.1/docs/resources/resource_group) | resource |
| [azurerm_service_plan.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.19.1/docs/resources/service_plan) | resource |
| [azurerm_storage_account.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.19.1/docs/resources/storage_account) | resource |
| [azurerm_windows_function_app.windows_function](https://registry.terraform.io/providers/hashicorp/azurerm/3.19.1/docs/resources/windows_function_app) | resource |
| [azurerm_application_insights.app_insights](https://registry.terraform.io/providers/hashicorp/azurerm/3.19.1/docs/data-sources/application_insights) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application to which the s3 bucket relates | `string` | `""` | no |
| <a name="input_application_insights_enabled"></a> [application\_insights\_enabled](#input\_application\_insights\_enabled) | Enable or disable the Application Insights deployment | `bool` | `true` | no |
| <a name="input_application_insights_id"></a> [application\_insights\_id](#input\_application\_insights\_id) | ID of the existing Application Insights to use instead of deploying a new one. | `string` | `null` | no |
| <a name="input_application_insights_log_analytics_workspace_id"></a> [application\_insights\_log\_analytics\_workspace\_id](#input\_application\_insights\_log\_analytics\_workspace\_id) | ID of the Log Analytics Workspace to be used with Application Insights | `string` | `null` | no |
| <a name="input_application_insights_retention"></a> [application\_insights\_retention](#input\_application\_insights\_retention) | Specify retention period (in days) for logs | `number` | `90` | no |
| <a name="input_application_insights_type"></a> [application\_insights\_type](#input\_application\_insights\_type) | Application Insights type if need to be generated. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights#application_type | `string` | `"web"` | no |
| <a name="input_application_zip_package_path"></a> [application\_zip\_package\_path](#input\_application\_zip\_package\_path) | Local or remote path of a zip package to deploy on the Function App | `string` | `null` | no |
| <a name="input_asp_instance_size"></a> [asp\_instance\_size](#input\_asp\_instance\_size) | The number of Workers (instances) to be allocated to the ASP | `number` | `1` | no |
| <a name="input_asp_os_type"></a> [asp\_os\_type](#input\_asp\_os\_type) | OS of the App Service Plan for Function App hosting | `string` | n/a | yes |
| <a name="input_asp_per_site_scaling_enabled"></a> [asp\_per\_site\_scaling\_enabled](#input\_asp\_per\_site\_scaling\_enabled) | Should Per Site Scaling be enabled | `bool` | `false` | no |
| <a name="input_asp_sku"></a> [asp\_sku](#input\_asp\_sku) | SKU of the App Service Plan for Function App hosting | `string` | `"S1"` | no |
| <a name="input_asp_zone_balancing_enabled"></a> [asp\_zone\_balancing\_enabled](#input\_asp\_zone\_balancing\_enabled) | Should the Service Plan balance across Availability Zones in the region | `bool` | `false` | no |
| <a name="input_attribute"></a> [attribute](#input\_attribute) | An attribute of the s3 bucket that makes it unique | `string` | `""` | no |
| <a name="input_builtin_logging_enabled"></a> [builtin\_logging\_enabled](#input\_builtin\_logging\_enabled) | Should built in logging be enabled | `bool` | `true` | no |
| <a name="input_client_certificate_enabled"></a> [client\_certificate\_enabled](#input\_client\_certificate\_enabled) | Should the function app use Client Certificates | `bool` | `null` | no |
| <a name="input_client_certificate_mode"></a> [client\_certificate\_mode](#input\_client\_certificate\_mode) | (Optional) The mode of the Function App's client certificates requirement for incoming requests. Possible values are `Required`, `Optional`, and `OptionalInteractiveUser`. | `string` | `null` | no |
| <a name="input_costcode"></a> [costcode](#input\_costcode) | Name of theDWP PRJ number (obtained from the project portfolio in TechNow) | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment into which resource is deployed | `string` | `""` | no |
| <a name="input_function_app_application_settings"></a> [function\_app\_application\_settings](#input\_function\_app\_application\_settings) | Function App application settings | `map(string)` | `{}` | no |
| <a name="input_function_app_application_settings_sensitive"></a> [function\_app\_application\_settings\_sensitive](#input\_function\_app\_application\_settings\_sensitive) | Function App application settings with sensitive values | `map(string)` | `{}` | no |
| <a name="input_function_app_version"></a> [function\_app\_version](#input\_function\_app\_version) | Version of the function app runtime to use (Allowed values 2, 3 or 4) | `number` | `4` | no |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | Disable http procotol and keep only https | `bool` | `true` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be an organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `""` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Name of the project or sqaud within the PDU which manages the resource. May be a persons name or email also | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"uksouth"` | no |
| <a name="input_site_config"></a> [site\_config](#input\_site\_config) | Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is not managed in this block. | `any` | `{}` | no |
| <a name="input_storage_account_account_replication_type"></a> [storage\_account\_account\_replication\_type](#input\_storage\_account\_account\_replication\_type) | Storage Account Replication Type | `string` | `"LRS"` | no |
| <a name="input_storage_account_authorized_ips"></a> [storage\_account\_authorized\_ips](#input\_storage\_account\_authorized\_ips) | IPs restriction for Function storage account in CIDR format | `list(string)` | `[]` | no |
| <a name="input_storage_account_enable_advanced_threat_protection"></a> [storage\_account\_enable\_advanced\_threat\_protection](#input\_storage\_account\_enable\_advanced\_threat\_protection) | Boolean flag which controls if advanced threat protection is enabled, see [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information. | `bool` | `false` | no |
| <a name="input_storage_account_enable_https_traffic_only"></a> [storage\_account\_enable\_https\_traffic\_only](#input\_storage\_account\_enable\_https\_traffic\_only) | Boolean flag which controls if https traffic only is enabled. | `bool` | `true` | no |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | Access key the storage account to use. If null a new storage account is created | `string` | `null` | no |
| <a name="input_storage_account_identity_ids"></a> [storage\_account\_identity\_ids](#input\_storage\_account\_identity\_ids) | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account | `list(string)` | `null` | no |
| <a name="input_storage_account_identity_type"></a> [storage\_account\_identity\_type](#input\_storage\_account\_identity\_type) | Specifies the type of Managed Service Identity that should be configured on this Storage Account | `string` | `null` | no |
| <a name="input_storage_account_kind"></a> [storage\_account\_kind](#input\_storage\_account\_kind) | Storage Account Kind | `string` | `"StorageV2"` | no |
| <a name="input_storage_account_min_tls_version"></a> [storage\_account\_min\_tls\_version](#input\_storage\_account\_min\_tls\_version) | Storage Account minimal TLS version | `string` | `"TLS1_2"` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Storage Account Name | `string` | `null` | no |
| <a name="input_storage_account_network_bypass"></a> [storage\_account\_network\_bypass](#input\_storage\_account\_network\_bypass) | Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of `Logging`, `Metrics`, `AzureServices`, or `None`. | `list(string)` | <pre>[<br>  "Logging",<br>  "Metrics",<br>  "AzureServices"<br>]</pre> | no |
| <a name="input_storage_account_network_rules_enabled"></a> [storage\_account\_network\_rules\_enabled](#input\_storage\_account\_network\_rules\_enabled) | Enable Storage account network default rules for functions | `bool` | `true` | no |
| <a name="input_storage_account_tier"></a> [storage\_account\_tier](#input\_storage\_account\_tier) | Storage Account Tier | `string` | `"Standard"` | no |
| <a name="input_type"></a> [type](#input\_type) | Name of service type | `string` | `""` | no |
| <a name="input_version_number"></a> [version\_number](#input\_version\_number) | The version of the application or object being deployed. This could be a build object or other artefact which is appended by a CI/Cd platform as part of a process of standing up an environment | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_insights_id"></a> [app\_insights\_id](#output\_app\_insights\_id) | The ID of the Application Insights component. |
| <a name="output_app_insights_instrumentation_key"></a> [app\_insights\_instrumentation\_key](#output\_app\_insights\_instrumentation\_key) | The instrumentation key of the Application Insights component. |
| <a name="output_function_app_id"></a> [function\_app\_id](#output\_function\_app\_id) | The ID of the Function App. |
| <a name="output_function_app_name"></a> [function\_app\_name](#output\_function\_app\_name) | The name of the Function App. |
| <a name="output_function_app_worker_count"></a> [function\_app\_worker\_count](#output\_function\_app\_worker\_count) | The number of workers of the Function App. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the Resource Group |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | The ID of the Storage Account. |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | The name of the Storage Account |
<!-- END_TF_DOCS -->
