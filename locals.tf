locals {
  app_insights = try(data.azurerm_application_insights.app_insights[0], try(azurerm_application_insights.app_insights[0], {}))

  default_application_settings = merge(
    var.application_insights_enabled ? {
      APPLICATION_INSIGHTS_IKEY             = try(local.app_insights.instrumentation_key, "")
      APPINSIGHTS_INSTRUMENTATIONKEY        = try(local.app_insights.instrumentation_key, "")
      APPLICATIONINSIGHTS_CONNECTION_STRING = try(local.app_insights.connection_string, "")
    } : {}
  )

  largefile_application_settings = (var.application == "LargeFileDownloadCleanup" ? { "material.alfrescoAzureStorageConnectionString" = data.azurerm_storage_account.st_acc.primary_access_key } : {})

  # If no subnet integration, allow function-app outbound IPs
  # function_out_ips = var.function_app_vnet_integration_subnet_id == null ? [] : distinct(concat(azurerm_linux_function_app.linux_function.possible_outbound_ip_addresses, azurerm_linux_function_app.linux_function.outbound_ip_addresses))
  # # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules#ip_rules
  # # > Small address ranges using "/31" or "/32" prefix sizes are not supported. These ranges should be configured using individual IP address rules without prefix specified.
  # storage_ips = distinct(flatten([for cidr in distinct(concat(local.function_out_ips, var.storage_account_authorized_ips)) :
  #   length(regexall("/3[12]$", cidr)) > 0 ? [cidrhost(cidr, 0), cidrhost(cidr, -1)] : [cidr]
  # ]))
}
