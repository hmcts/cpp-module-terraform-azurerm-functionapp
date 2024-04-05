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
  virtual_network_subnet_id   = var.create_subnet && length(var.subnet_name) == 0 ? azurerm_subnet.main[0].id : null
  tags                        = var.tags

  app_settings = merge(
    var.application_settings,
    local.application_settings_sensitive_keyvault_lookup,
    local.application_settings_sensitive_hashicorp_vault_lookup
  )

  lifecycle {
    ignore_changes = [
      app_settings.WEBSITE_RUN_FROM_ZIP,
      app_settings.WEBSITE_RUN_FROM_PACKAGE,
      app_settings.MACHINEKEY_DecryptionKey,
      app_settings.WEBSITE_CONTENTAZUREFILECONNECTIONSTRING,
      app_settings.WEBSITE_CONTENTSHARE
    ]
  }

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
      application_insights_connection_string = lookup(site_config.value, "worker_app_insights_connection_stringcount", null)
      application_insights_key               = lookup(site_config.value, "app_insights_instrumentation_key", null)

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
  virtual_network_subnet_id   = var.create_subnet && length(var.subnet_name) == 0 ? azurerm_subnet.main[0].id : null
  tags                        = var.tags

  app_settings = merge(
    var.application_settings,
    local.application_settings_sensitive_keyvault_lookup,
    local.application_settings_sensitive_hashicorp_vault_lookup
  )

  lifecycle {
    ignore_changes = [
      app_settings.WEBSITE_RUN_FROM_ZIP,
      app_settings.WEBSITE_RUN_FROM_PACKAGE,
      app_settings.MACHINEKEY_DecryptionKey,
      app_settings.WEBSITE_CONTENTAZUREFILECONNECTIONSTRING,
      app_settings.WEBSITE_CONTENTSHARE
    ]
  }

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
      application_insights_connection_string = lookup(site_config.value, "worker_app_insights_connection_stringcount", null)
      application_insights_key               = lookup(site_config.value, "app_insights_instrumentation_key", null)

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
}

resource "null_resource" "functionapp_deploy" {
  triggers = {
    functionapp_package = var.functionapp_package
  }
  provisioner "local-exec" {
    command = <<EOT
    curl -k ${var.functionapp_package} -o ${var.function_app_name}.zip
    az functionapp deployment source config-zip --src ${var.function_app_name}.zip -g ${var.resource_group_name} -n ${var.function_app_name}
    rm ${var.function_app_name}.zip
    sleep 60
    EOT
  }
  depends_on = [
    azurerm_linux_function_app.linux_function,
    azurerm_windows_function_app.windows_function
  ]
}

data "azurerm_function_app_host_keys" "main" {
  name                = var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.name : azurerm_windows_function_app.windows_function.0.name
  resource_group_name = var.resource_group_name
  depends_on = [
    null_resource.functionapp_deploy
  ]
}

resource "azurerm_app_service_public_certificate" "functionapp" {
  for_each             = var.cert_contents
  resource_group_name  = var.resource_group_name
  app_service_name     = var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.name : azurerm_windows_function_app.windows_function.0.name
  certificate_name     = each.key
  certificate_location = "CurrentUserMy"
  blob                 = each.value
}
