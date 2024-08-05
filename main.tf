
# App Service Plan
resource "azurerm_service_plan" "main" {
  count                    = var.create_service_plan ? 1 : 0
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

data "azurerm_service_plan" "sp" {
  #count               = length(azurerm_service_plan.main[0].id) != 0 ? 1 : 0
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_service_plan.main
  ]
}

# Function App
resource "azurerm_linux_function_app" "linux_function" {
  count           = var.asp_os_type == "Linux" ? 1 : 0
  name            = var.function_app_name
  service_plan_id = data.azurerm_service_plan.sp.id
  #service_plan_id             = data.azurerm_service_plan.sp[0].id
  location                    = var.location
  resource_group_name         = var.resource_group_name
  storage_account_name        = var.storage_account_name
  storage_account_access_key  = var.storage_account_access_key
  functions_extension_version = "~${var.function_app_version}"
  https_only                  = var.https_only
  client_certificate_enabled  = var.client_certificate_enabled
  client_certificate_mode     = var.client_certificate_mode
  builtin_logging_enabled     = var.builtin_logging_enabled
  virtual_network_subnet_id   = length(var.subnet_name) == 0 ? azurerm_subnet.main[0].id : data.azurerm_subnet.main.0.id
  tags                        = var.tags

  dynamic "identity" {
    for_each = var.identity == {} ? [] : [var.identity]
    content {
      type         = lookup(identity.value, "type", null)
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  storage_account {
    access_key   = lookup(var.storage_account, "access_key", null)
    account_name = lookup(var.storage_account, "account_name", null)
    name         = lookup(var.storage_account, "name", "certs")
    share_name   = lookup(var.storage_account, "share_name", "certs")
    type         = lookup(var.storage_account, "type", "AzureFiles")
    mount_path   = lookup(var.storage_account, "mount_path", "/certs")
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

  lifecycle {
    ignore_changes = [
      app_settings,
    ]
  }
}

# Check app_service_plan; for example, azurerm_app_service_plan.example.id
resource "azurerm_private_endpoint" "private_endpoint" {
  count               = contains(var.private_endpoint_skus, var.asp_sku) ? 1 : 0
  name                = var.private_endpoint
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.ingress.id

  private_service_connection {
    name                           = var.private_service_connection
    private_connection_resource_id = var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.id : azurerm_windows_function_app.windows_function.0.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}

# Integrate with VNet
data "azurerm_subnet" "ingress" {
  name                 = var.ingress_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg_name
}

resource "azurerm_app_service_virtual_network_swift_connection" "private_function_vnet_link" {
  count          = contains(var.private_endpoint_skus, var.asp_sku) ? 1 : 0
  app_service_id = var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.id : azurerm_windows_function_app.windows_function.0.id
  subnet_id      = data.azurerm_subnet.ingress.id
}


resource "azurerm_subnet" "main" {
  count                = var.create_subnet && length(var.subnet_cidr) != 0 && length(var.subnet_name) == 0 ? 1 : 0
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
    azurerm_service_plan.main
  ]
}

data "azurerm_subnet" "main" {
  count = length(var.subnet_name) != 0 ? 1 : 0
  #count                = length(var.subnet_name) != 0 && length(azurerm_subnet.main[0].id) !=0  ? 1 : 0
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg_name
  depends_on = [
    azurerm_subnet.main[0]
  ]
}

resource "azurerm_windows_function_app" "windows_function" {
  count           = var.asp_os_type == "Windows" ? 1 : 0
  name            = var.function_app_name
  service_plan_id = data.azurerm_service_plan.sp.id
  # service_plan_id             = data.azurerm_service_plan.sp[0].id
  location                    = var.location
  resource_group_name         = var.resource_group_name
  storage_account_name        = var.storage_account_name
  storage_account_access_key  = var.storage_account_access_key
  functions_extension_version = "~${var.function_app_version}"
  https_only                  = var.https_only
  client_certificate_enabled  = var.client_certificate_enabled
  client_certificate_mode     = var.client_certificate_mode
  builtin_logging_enabled     = var.builtin_logging_enabled
  virtual_network_subnet_id   = length(var.subnet_name) == 0 ? azurerm_subnet.main[0].id : data.azurerm_subnet.main.0.id
  tags                        = var.tags

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
      http2_enabled                          = lookup(site_config.value, "http2_enabled", null)
      minimum_tls_version                    = lookup(site_config.value, "minimum_tls_version", null)
      elastic_instance_minimum               = lookup(site_config.value, "elastic_instance_minimum", null)
      worker_count                           = lookup(site_config.value, "worker_count", null)
      application_insights_connection_string = lookup(site_config.value, "application_insights_connection_string", null)
      application_insights_key               = lookup(site_config.value, "application_insights_key", null)

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
  lifecycle {
    ignore_changes = [
      app_settings,
    ]
  }
}

data "azurerm_function_app_host_keys" "main" {
  name                = var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.name : azurerm_windows_function_app.windows_function.0.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_app_service_public_certificate" "functionapp" {
  for_each             = var.cert_contents
  resource_group_name  = var.resource_group_name
  app_service_name     = var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.name : azurerm_windows_function_app.windows_function.0.name
  certificate_name     = each.key
  certificate_location = "CurrentUserMy"
  blob                 = each.value
}
