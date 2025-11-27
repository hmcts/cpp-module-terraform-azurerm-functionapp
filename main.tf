# App Service Plan

locals {
  post_private_endpoint_sleep_duration = "60s"
  is_ep                                = contains(["EP1", "EP2", "EP3"], upper(var.asp_sku))
}

resource "azurerm_service_plan" "main_ep" {
  count                        = var.create_service_plan && local.is_ep ? 1 : 0
  name                         = var.service_plan_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  os_type                      = var.asp_os_type
  sku_name                     = var.asp_sku
  worker_count                 = var.asp_instance_size
  maximum_elastic_worker_count = var.asp_maximum_elastic_worker_count != null ? var.asp_maximum_elastic_worker_count : var.asp_instance_size
  per_site_scaling_enabled     = var.asp_per_site_scaling_enabled
  zone_balancing_enabled       = var.asp_zone_balancing_enabled
  tags                         = var.tags
}

resource "azurerm_service_plan" "main" {
  count                    = var.create_service_plan && local.is_ep ? 1 : 0
  name                     = var.service_plan_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  os_type                  = var.asp_os_type
  sku_name                 = var.asp_sku
  worker_count             = var.asp_instance_size
  per_site_scaling_enabled = var.asp_per_site_scaling_enabled
  zone_balancing_enabled   = var.asp_zone_balancing_enabled
  tags                     = var.tags
}

resource "azurerm_monitor_autoscale_setting" "auto" {
  count               = var.enable_autoscale ? 1 : 0
  name                = "auto-scale-set-${var.service_plan_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = data.azurerm_service_plan.sp.id
  tags                = var.tags
  profile {
    name = "default"
    capacity {
      default = var.autoscale_config.default_count
      minimum = var.autoscale_config.minimum_instances_count == null ? var.autoscale_config.default_count : var.autoscale_config.minimum_instances_count
      maximum = var.autoscale_config.maximum_instances_count
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = data.azurerm_service_plan.sp.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.autoscale_config.scale_out_cpu_percentage_threshold
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = var.autoscale_config.scaling_action_increase_cpu_instances_number
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = data.azurerm_service_plan.sp.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.autoscale_config.scale_in_cpu_percentage_threshold
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = var.autoscale_config.scaling_action_decrease_cpu_instances_number
        cooldown  = "PT1M"
      }
    }
    rule {
      metric_trigger {
        metric_name        = "MemoryPercentage"
        metric_resource_id = data.azurerm_service_plan.sp.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.autoscale_config.scale_out_memory_percentage_threshold
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = var.autoscale_config.scaling_action_increase_memory_instances_number
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "MemoryPercentage"
        metric_resource_id = data.azurerm_service_plan.sp.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.autoscale_config.scale_in_memory_percentage_threshold
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = var.autoscale_config.scaling_action_decrease_memory_instances_number
        cooldown  = "PT5M"
      }
    }
  }
}
data "azurerm_service_plan" "sp" {
  #count               = length(azurerm_service_plan.main[0].id) != 0 ? 1 : 0
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_service_plan.main,
    azurerm_service_plan.main_ep
  ]
}

# Function App
resource "azurerm_linux_function_app" "linux_function" {
  count           = var.create_function_app && var.asp_os_type == "Linux" ? 1 : 0
  name            = var.function_app_name
  service_plan_id = data.azurerm_service_plan.sp.id
  #service_plan_id             = data.azurerm_service_plan.sp[0].id
  location                      = var.location
  resource_group_name           = var.resource_group_name
  storage_account_name          = var.storage_account_name
  storage_account_access_key    = var.storage_account_access_key
  functions_extension_version   = "~${var.function_app_version}"
  https_only                    = var.https_only
  client_certificate_enabled    = var.client_certificate_enabled
  client_certificate_mode       = var.client_certificate_mode
  builtin_logging_enabled       = var.builtin_logging_enabled
  virtual_network_subnet_id     = var.create_subnet && length(var.subnet_cidr) != 0 ? azurerm_subnet.main[0].id : var.subnet_id
  public_network_access_enabled = var.public_network_access_override

  dynamic "identity" {
    for_each = var.identity == {} ? [] : [var.identity]
    content {
      type         = lookup(identity.value, "type", null)
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }
  dynamic "storage_account" {
    for_each = var.storage_account == {} ? [] : ["cert"]
    content {
      access_key   = lookup(var.storage_account, "access_key", null)
      account_name = lookup(var.storage_account, "account_name", null)
      name         = lookup(var.storage_account, "name", "certs")
      share_name   = lookup(var.storage_account, "share_name", "certs")
      type         = lookup(var.storage_account, "type", "AzureFiles")
      mount_path   = lookup(var.storage_account, "mount_path", "/certs")
    }
  }

  dynamic "site_config" {
    for_each = [var.site_config]
    content {
      always_on                              = lookup(site_config.value, "always_on", null)
      app_scale_limit                        = lookup(site_config.value, "app_scale_limit", null)
      http2_enabled                          = lookup(site_config.value, "http2_enabled", null)
      minimum_tls_version                    = lookup(site_config.value, "minimum_tls_version", null)
      elastic_instance_minimum               = lookup(site_config.value, "elastic_instance_minimum", null)
      worker_count                           = lookup(site_config.value, "worker_count", null)
      application_insights_connection_string = lookup(site_config.value, "application_insights_connection_string", null)
      application_insights_key               = lookup(site_config.value, "application_insights_key", null)
      vnet_route_all_enabled                 = lookup(site_config.value, "vnet_route_all_enabled", null)
      dynamic "cors" {
        for_each = lookup(site_config.value, "cors", null) == null ? [] : ["cors"]
        content {
          allowed_origins     = lookup(var.site_config.cors, "allowed_origins", [])
          support_credentials = lookup(var.site_config.cors, "support_credentials", false)
        }
      }

      dynamic "application_stack" {
        for_each = lookup(site_config.value, "application_stack", null) == null ? [] : ["application_stack"]
        content {
          dotnet_version              = lookup(var.site_config.application_stack, "dotnet_version", null)
          use_dotnet_isolated_runtime = lookup(var.site_config.application_stack, "use_dotnet_isolated_runtime", null)
          java_version                = lookup(var.site_config.application_stack, "java_version", null)
          node_version                = lookup(var.site_config.application_stack, "node_version", null)
          python_version              = lookup(var.site_config.application_stack, "python_version", null)
          powershell_core_version     = lookup(var.site_config.application_stack, "powershell_core_version", null)
          use_custom_runtime          = lookup(var.site_config.application_stack, "use_custom_runtime", null)
        }
      }
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      app_settings,
    ]
  }
}

# Check app_service_plan; for example, azurerm_app_service_plan.example.id
resource "azurerm_private_endpoint" "private_endpoint" {
  count               = var.create_function_app && !var.public_network_access_override ? 1 : 0
  name                = var.private_endpoint
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_ingress_id != null ? var.subnet_ingress_id : azurerm_subnet.ingress[0].id
  tags                = var.tags
  private_service_connection {
    name                           = var.private_service_connection
    private_connection_resource_id = var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.id : azurerm_windows_function_app.windows_function.0.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.dns_zone[0].id]
  }

  provisioner "local-exec" {
    command = "sleep ${local.post_private_endpoint_sleep_duration}"
  }

  depends_on = [
    azurerm_subnet.ingress
  ]
}

data "azurerm_virtual_network" "vnet" {
  # vnet should only exist when utilising a private endpoint compatible SKU
  count               = var.create_function_app && !var.public_network_access_override ? 1 : 0
  name                = var.vnet_name
  resource_group_name = var.vnet_rg_name
}

resource "azurerm_subnet" "main" {
  count                = var.create_subnet && length(var.subnet_cidr) != 0 ? 1 : 0
  name                 = "SN-${upper(var.function_app_name)}"
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnet_cidr
  resource_group_name  = var.vnet_rg_name

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
  depends_on = [
    azurerm_service_plan.main,
    azurerm_service_plan.main_ep
  ]
}

resource "azurerm_subnet" "ingress" {
  count                             = var.create_ingress_subnet && length(var.subnet_ingress_cidr) != 0 ? 1 : 0
  name                              = "SN-${upper(var.function_app_name)}-PE"
  virtual_network_name              = var.vnet_name
  address_prefixes                  = var.subnet_ingress_cidr
  resource_group_name               = var.vnet_rg_name
  private_endpoint_network_policies = "Enabled"
  service_endpoints                 = ["Microsoft.Storage"]
}

resource "azurerm_windows_function_app" "windows_function" {
  count           = var.create_function_app && var.asp_os_type == "Windows" ? 1 : 0
  name            = var.function_app_name
  service_plan_id = data.azurerm_service_plan.sp.id
  # service_plan_id             = data.azurerm_service_plan.sp[0].id
  location                      = var.location
  resource_group_name           = var.resource_group_name
  storage_account_name          = var.storage_account_name
  storage_account_access_key    = var.storage_account_access_key
  functions_extension_version   = "~${var.function_app_version}"
  https_only                    = var.https_only
  client_certificate_enabled    = var.client_certificate_enabled
  client_certificate_mode       = var.client_certificate_mode
  builtin_logging_enabled       = var.builtin_logging_enabled
  virtual_network_subnet_id     = var.create_subnet && length(var.subnet_cidr) != 0 ? azurerm_subnet.main[0].id : var.subnet_id
  public_network_access_enabled = var.public_network_access_override
  app_settings = (
    var.asp_os_type == "Windows" && var.storage_account_is_public_enable_map ? {
      WEBSITE_VNET_ROUTE_ALL                   = "1"
      WEBSITE_CONTENTAZUREFILECONNECTIONSTRING = var.storage_account_connection_string
      WEBSITE_CONTENTSHARE                     = var.storage_content_share
      WEBSITE_CONTENTOVERVNET                  = "1"
    } : {}
  )
  dynamic "identity" {
    for_each = var.identity == {} ? [] : [var.identity]
    content {
      type         = lookup(identity.value, "type", null)
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  dynamic "site_config" {
    for_each = [var.site_config]
    content {
      always_on                              = lookup(site_config.value, "always_on", null)
      app_scale_limit                        = lookup(site_config.value, "app_scale_limit", null)
      vnet_route_all_enabled                 = lookup(site_config.value, "vnet_route_all_enabled", null)
      http2_enabled                          = lookup(site_config.value, "http2_enabled", null)
      minimum_tls_version                    = lookup(site_config.value, "minimum_tls_version", null)
      elastic_instance_minimum               = lookup(site_config.value, "elastic_instance_minimum", null)
      worker_count                           = lookup(site_config.value, "worker_count", null)
      application_insights_connection_string = lookup(site_config.value, "application_insights_connection_string", null)
      application_insights_key               = lookup(site_config.value, "application_insights_key", null)
      runtime_scale_monitoring_enabled       = lookup(site_config.value, "runtime_scale_monitoring_enabled", null)
      dynamic "cors" {
        for_each = lookup(site_config.value, "cors", null) == null ? [] : ["cors"]
        content {
          allowed_origins     = lookup(var.site_config.cors, "allowed_origins", [])
          support_credentials = lookup(var.site_config.cors, "support_credentials", false)
        }
      }

      dynamic "app_service_logs" {
        for_each = lookup(site_config.value, "app_service_logs", null) == null ? [] : ["app_service_logs"]
        content {
          disk_quota_mb         = lookup(var.site_config.app_service_logs, "disk_quota_mb", null)
          retention_period_days = lookup(var.site_config.app_service_logs, "retention_period_days", null)
        }
      }

      dynamic "application_stack" {
        for_each = lookup(site_config.value, "application_stack", null) == null ? [] : ["application_stack"]
        content {
          dotnet_version              = lookup(var.site_config.application_stack, "dotnet_version", null)
          use_dotnet_isolated_runtime = lookup(var.site_config.application_stack, "use_dotnet_isolated_runtime", null)
          java_version                = lookup(var.site_config.application_stack, "java_version", null)
          node_version                = lookup(var.site_config.application_stack, "node_version", null)
          powershell_core_version     = lookup(var.site_config.application_stack, "powershell_core_version", null)
          use_custom_runtime          = lookup(var.site_config.application_stack, "use_custom_runtime", null)
        }
      }
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [app_settings]
  }
}

data "azurerm_function_app_host_keys" "main" {
  count               = var.create_function_app ? 1 : 0
  name                = var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.name : azurerm_windows_function_app.windows_function.0.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_app_service_public_certificate" "functionapp" {
  for_each             = var.create_function_app ? var.cert_contents : {}
  resource_group_name  = var.resource_group_name
  app_service_name     = var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.name : azurerm_windows_function_app.windows_function.0.name
  certificate_name     = each.key
  certificate_location = "CurrentUserMy"
  blob                 = each.value
}

# Link Private DNS zone to VNet and disable public address to Function App
# Private DNS Zone should already exist via cpp-terraform-network

data "azurerm_private_dns_zone" "dns_zone" {
  name                = "privatelink.azurewebsites.net"
  count               = var.create_function_app && !var.public_network_access_override ? 1 : 0
  resource_group_name = var.dns_resource_group_name
}

# resource "azurerm_private_dns_a_record" "dns_record" {
#   name                = var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.name : azurerm_windows_function_app.windows_function.0.name
#   count               = var.create_function_app && !var.public_network_access_override ? 1 : 0
#   zone_name           = data.azurerm_private_dns_zone.dns_zone[0].name
#   resource_group_name = var.dns_resource_group_name
#   ttl                 = 300
#   records             = [azurerm_private_endpoint.private_endpoint[0].private_service_connection[0].private_ip_address]
# }
