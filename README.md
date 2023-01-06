<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.38.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.12.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_virtual_network_swift_connection.linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_virtual_network_swift_connection) | resource |
| [azurerm_app_service_virtual_network_swift_connection.windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_virtual_network_swift_connection) | resource |
| [azurerm_linux_function_app.linux_function](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app) | resource |
| [azurerm_service_plan.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_subnet.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_windows_function_app.windows_function](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app) | resource |
| [null_resource.functionapp_deploy](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azurerm_function_app_host_keys.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/function_app_host_keys) | data source |
| [azurerm_key_vault_secret.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_service_plan.sp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/service_plan) | data source |
| [azurerm_virtual_network.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [vault_generic_secret.main](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_settings"></a> [application\_settings](#input\_application\_settings) | Function App application settings | `map(string)` | `{}` | no |
| <a name="input_application_settings_sensitive_hashicorp_vault_lookup"></a> [application\_settings\_sensitive\_hashicorp\_vault\_lookup](#input\_application\_settings\_sensitive\_hashicorp\_vault\_lookup) | Function App application settings lookup from Hashicorp vault | `map(string)` | `{}` | no |
| <a name="input_application_settings_sensitive_keyvault_lookup"></a> [application\_settings\_sensitive\_keyvault\_lookup](#input\_application\_settings\_sensitive\_keyvault\_lookup) | Function App application settings lookup from keyvault | `map(string)` | `{}` | no |
| <a name="input_asp_instance_size"></a> [asp\_instance\_size](#input\_asp\_instance\_size) | The number of Workers (instances) to be allocated to the ASP | `number` | `1` | no |
| <a name="input_asp_os_type"></a> [asp\_os\_type](#input\_asp\_os\_type) | OS of the App Service Plan for Function App hosting | `string` | n/a | yes |
| <a name="input_asp_per_site_scaling_enabled"></a> [asp\_per\_site\_scaling\_enabled](#input\_asp\_per\_site\_scaling\_enabled) | Should Per Site Scaling be enabled | `bool` | `false` | no |
| <a name="input_asp_sku"></a> [asp\_sku](#input\_asp\_sku) | SKU of the App Service Plan for Function App hosting | `string` | `"S1"` | no |
| <a name="input_asp_zone_balancing_enabled"></a> [asp\_zone\_balancing\_enabled](#input\_asp\_zone\_balancing\_enabled) | Should the Service Plan balance across Availability Zones in the location | `bool` | `false` | no |
| <a name="input_builtin_logging_enabled"></a> [builtin\_logging\_enabled](#input\_builtin\_logging\_enabled) | Should built in logging be enabled | `bool` | `true` | no |
| <a name="input_client_certificate_enabled"></a> [client\_certificate\_enabled](#input\_client\_certificate\_enabled) | Should the function app use Client Certificates | `bool` | `null` | no |
| <a name="input_client_certificate_mode"></a> [client\_certificate\_mode](#input\_client\_certificate\_mode) | (Optional) The mode of the Function App's client certificates requirement for incoming requests. Possible values are `Required`, `Optional`, and `OptionalInteractiveUser`. | `string` | `null` | no |
| <a name="input_create_service_plan"></a> [create\_service\_plan](#input\_create\_service\_plan) | If true a new service plan is created | `bool` | `true` | no |
| <a name="input_create_subnet"></a> [create\_subnet](#input\_create\_subnet) | Should Create Subnet | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment into which resource is deployed | `string` | `""` | no |
| <a name="input_function_app_name"></a> [function\_app\_name](#input\_function\_app\_name) | n/a | `string` | n/a | yes |
| <a name="input_function_app_version"></a> [function\_app\_version](#input\_function\_app\_version) | Version of the function app runtime to use (Allowed values 2, 3 or 4) | `number` | `4` | no |
| <a name="input_functionapp_package"></a> [functionapp\_package](#input\_functionapp\_package) | The ZIP file location of the functionapp package | `string` | n/a | yes |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | Disable http procotol and keep only https | `bool` | `true` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | keyvault id to lookup secret settings | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"uksouth"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_service_plan_name"></a> [service\_plan\_name](#input\_service\_plan\_name) | Service Plan Name | `string` | `null` | no |
| <a name="input_site_config"></a> [site\_config](#input\_site\_config) | Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is not managed in this block. | `any` | `{}` | no |
| <a name="input_storage_account_access_key"></a> [storage\_account\_access\_key](#input\_storage\_account\_access\_key) | Storage account access key to be used by function app | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Storage account to associate with function app | `string` | n/a | yes |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | Vnet Subnet CIDR | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Vnet Name for Private Subnets | `string` | `""` | no |
| <a name="input_vnet_rg_name"></a> [vnet\_rg\_name](#input\_vnet\_rg\_name) | Vnet Resource Group Name for Private Subnets | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_app_id"></a> [function\_app\_id](#output\_function\_app\_id) | The ID of the Function App. |
| <a name="output_function_app_name"></a> [function\_app\_name](#output\_function\_app\_name) | The name of the Function App. |
| <a name="output_function_app_primary_key"></a> [function\_app\_primary\_key](#output\_function\_app\_primary\_key) | Primary Key for Function App |
| <a name="output_function_app_worker_count"></a> [function\_app\_worker\_count](#output\_function\_app\_worker\_count) | The number of workers of the Function App. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the Resource Group |
<!-- END_TF_DOCS -->
