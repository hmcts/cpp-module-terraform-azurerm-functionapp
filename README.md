
# AzureRM FunctionApp Module

When developing new features to this module, do not forget to update [for_terratest.tfvars](examples/complete/for_terratest.tfvars) file so terratest does not fail. You can read [README.md](tests/terratest/README.md) for more details

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_public_certificate.functionapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_public_certificate) | resource |
| [azurerm_linux_function_app.linux_function](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app) | resource |
| [azurerm_monitor_autoscale_setting.auto](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_autoscale_setting) | resource |
| [azurerm_private_endpoint.private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_service_plan.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_subnet.ingress](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_windows_function_app.windows_function](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app) | resource |
| [azurerm_function_app_host_keys.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/function_app_host_keys) | data source |
| [azurerm_private_dns_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_service_plan.sp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/service_plan) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asp_instance_size"></a> [asp\_instance\_size](#input\_asp\_instance\_size) | The number of Workers (instances) to be allocated to the ASP | `number` | `1` | no |
| <a name="input_asp_maximum_elastic_worker_count"></a> [asp\_maximum\_elastic\_worker\_count](#input\_asp\_maximum\_elastic\_worker\_count) | Max burst size | `number` | `null` | no |
| <a name="input_asp_os_type"></a> [asp\_os\_type](#input\_asp\_os\_type) | OS of the App Service Plan for Function App hosting | `string` | n/a | yes |
| <a name="input_asp_per_site_scaling_enabled"></a> [asp\_per\_site\_scaling\_enabled](#input\_asp\_per\_site\_scaling\_enabled) | Should Per Site Scaling be enabled | `bool` | `false` | no |
| <a name="input_asp_sku"></a> [asp\_sku](#input\_asp\_sku) | SKU of the App Service Plan for Function App hosting | `string` | `"S1"` | no |
| <a name="input_asp_zone_balancing_enabled"></a> [asp\_zone\_balancing\_enabled](#input\_asp\_zone\_balancing\_enabled) | Should the Service Plan balance across Availability Zones in the location | `bool` | `false` | no |
| <a name="input_autoscale_config"></a> [autoscale\_config](#input\_autoscale\_config) | if autoscale is enabled for app service plan, required configuration to be passed | `any` | `{}` | no |
| <a name="input_builtin_logging_enabled"></a> [builtin\_logging\_enabled](#input\_builtin\_logging\_enabled) | Should built in logging be enabled | `bool` | `true` | no |
| <a name="input_cert_contents"></a> [cert\_contents](#input\_cert\_contents) | Root ca cert content | `map(string)` | `{}` | no |
| <a name="input_client_certificate_enabled"></a> [client\_certificate\_enabled](#input\_client\_certificate\_enabled) | Should the function app use Client Certificates | `bool` | `null` | no |
| <a name="input_client_certificate_mode"></a> [client\_certificate\_mode](#input\_client\_certificate\_mode) | (Optional) The mode of the Function App's client certificates requirement for incoming requests. Possible values are `Required`, `Optional`, and `OptionalInteractiveUser`. | `string` | `null` | no |
| <a name="input_create_function_app"></a> [create\_function\_app](#input\_create\_function\_app) | If true, creates the Function App. Set to false to deploy only the App Service Plan. | `bool` | `true` | no |
| <a name="input_create_ingress_subnet"></a> [create\_ingress\_subnet](#input\_create\_ingress\_subnet) | Should Create Subnet for PE | `bool` | `false` | no |
| <a name="input_create_service_plan"></a> [create\_service\_plan](#input\_create\_service\_plan) | If true a new service plan is created | `bool` | `true` | no |
| <a name="input_create_subnet"></a> [create\_subnet](#input\_create\_subnet) | Should Create Subnet | `bool` | `false` | no |
| <a name="input_dns_link"></a> [dns\_link](#input\_dns\_link) | Name of DNS link connecting private DNS zone to VNet | `string` | `""` | no |
| <a name="input_dns_resource_group_name"></a> [dns\_resource\_group\_name](#input\_dns\_resource\_group\_name) | Name of private DNS zone resource group | `string` | `""` | no |
| <a name="input_enable_autoscale"></a> [enable\_autoscale](#input\_enable\_autoscale) | If true a scaling rule is configured | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment into which resource is deployed | `string` | `""` | no |
| <a name="input_function_app_name"></a> [function\_app\_name](#input\_function\_app\_name) | Name of the Function App | `string` | `null` | no |
| <a name="input_function_app_version"></a> [function\_app\_version](#input\_function\_app\_version) | Version of the function app runtime to use (Allowed values 2, 3 or 4) | `number` | `4` | no |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | Disable http procotol and keep only https | `bool` | `true` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Identity block Specifies the identity to assign to function app | `any` | `{}` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | keyvault id to lookup secret settings | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"uksouth"` | no |
| <a name="input_private_dns_zone_name"></a> [private\_dns\_zone\_name](#input\_private\_dns\_zone\_name) | Name for private dns zone | `string` | `"privatelink.azurewebsites.net"` | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | Name of private endpoint | `string` | `""` | no |
| <a name="input_private_endpoint_skus"></a> [private\_endpoint\_skus](#input\_private\_endpoint\_skus) | n/a | `list(any)` | <pre>[<br/>  "EP1",<br/>  "EP2",<br/>  "EP3",<br/>  "FC1"<br/>]</pre> | no |
| <a name="input_private_service_connection"></a> [private\_service\_connection](#input\_private\_service\_connection) | Name for private service connection | `string` | `"test"` | no |
| <a name="input_public_network_access_override"></a> [public\_network\_access\_override](#input\_public\_network\_access\_override) | Override the default logic of enabling public access only on non-private endpoint SKUs | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_service_plan_name"></a> [service\_plan\_name](#input\_service\_plan\_name) | Service Plan Name | `string` | `null` | no |
| <a name="input_site_config"></a> [site\_config](#input\_site\_config) | Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is not managed in this block. | `any` | `{}` | no |
| <a name="input_storage_account"></a> [storage\_account](#input\_storage\_account) | storage account to mount | `any` | `{}` | no |
| <a name="input_storage_account_access_key"></a> [storage\_account\_access\_key](#input\_storage\_account\_access\_key) | Storage account access key to be used by function app | `string` | `null` | no |
| <a name="input_storage_account_connection_string"></a> [storage\_account\_connection\_string](#input\_storage\_account\_connection\_string) | Storage account access key to be used by function app | `string` | `null` | no |
| <a name="input_storage_account_is_public_enable_map"></a> [storage\_account\_is\_public\_enable\_map](#input\_storage\_account\_is\_public\_enable\_map) | flag to create appsettings | `bool` | `false` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Storage account to associate with function app | `string` | `""` | no |
| <a name="input_storage_content_share"></a> [storage\_content\_share](#input\_storage\_content\_share) | Storage account file share name only for windows and private storage account | `string` | `""` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | Vnet Subnet CIDR | `list(string)` | `[]` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID to use | `string` | `null` | no |
| <a name="input_subnet_ingress_cidr"></a> [subnet\_ingress\_cidr](#input\_subnet\_ingress\_cidr) | Vnet Subnet CIDR for PEs | `list(string)` | `[]` | no |
| <a name="input_subnet_ingress_id"></a> [subnet\_ingress\_id](#input\_subnet\_ingress\_id) | Subnet ID to use for PE | `string` | `null` | no |
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
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | Principal ID of the Function APP |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the Resource Group |
| <a name="output_service_plan_id"></a> [service\_plan\_id](#output\_service\_plan\_id) | The ID of the App Service Plan |
| <a name="output_service_plan_name"></a> [service\_plan\_name](#output\_service\_plan\_name) | The name of the App Service Plan |
<!-- END_TF_DOCS -->
