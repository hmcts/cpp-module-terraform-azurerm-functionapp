module "tag_set" {
  source         = "git::https://github.com/hmcts/cpp-module-terraform-azurerm-tag-generator.git?ref=main"
  namespace      = var.namespace
  application    = var.application
  costcode       = var.costcode
  owner          = var.owner
  version_number = var.version_number
  attribute      = var.attribute
  environment    = var.environment
  type           = var.type
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.environment}-${var.namespace}-${var.application_group}"
  location = var.region
}

# Storage Account
resource "azurerm_storage_account" "main" {
  count                           = var.create_storage_account ? 1 : 0
  name                            = var.storage_account_name
  location                        = var.region
  resource_group_name             = azurerm_resource_group.main.name
  account_replication_type        = var.storage_account_account_replication_type
  account_tier                    = var.storage_account_tier
  account_kind                    = var.storage_account_kind
  min_tls_version                 = var.storage_account_min_tls_version
  allow_nested_items_to_be_public = false
  enable_https_traffic_only       = var.storage_account_enable_https_traffic_only
  tags                            = module.tag_set.tags

  dynamic "identity" {
    for_each = var.storage_account_identity_type == null ? [] : [1]
    content {
      type         = var.storage_account_identity_type
      identity_ids = var.storage_account_identity_ids == "UserAssigned" ? var.storage_account_identity_ids : null
    }
  }
}

data "azurerm_storage_account" "st_acc" {
  name                = var.storage_account_name
  resource_group_name = azurerm_resource_group.main.name
  depends_on = [
    azurerm_storage_account.main
  ]
}

# App Service Plan
resource "azurerm_service_plan" "main" {
  count                    = var.create_service_plan ? 1 : 0
  name                     = var.service_plan_name
  location                 = var.region
  resource_group_name      = azurerm_resource_group.main.name
  os_type                  = var.asp_os_type
  sku_name                 = var.asp_sku
  worker_count             = var.asp_instance_size
  per_site_scaling_enabled = var.asp_per_site_scaling_enabled
  zone_balancing_enabled   = var.asp_zone_balancing_enabled
  tags                     = module.tag_set.tags
}


data "azurerm_service_plan" "sp" {
  name                = var.service_plan_name
  resource_group_name = azurerm_resource_group.main.name
  depends_on = [
    azurerm_service_plan.main
  ]
}

# Function App
resource "azurerm_linux_function_app" "linux_function" {
  count                       = var.asp_os_type == "Linux" ? 1 : 0
  name                        = "fa-${var.environment}-${var.namespace}-${var.application}"
  service_plan_id             = data.azurerm_service_plan.sp.id
  location                    = var.region
  resource_group_name         = azurerm_resource_group.main.name
  storage_account_name        = var.storage_account_name
  storage_account_access_key  = data.azurerm_storage_account.st_acc.primary_access_key
  functions_extension_version = "~${var.function_app_version}"
  https_only                  = var.https_only
  client_certificate_enabled  = var.client_certificate_enabled
  client_certificate_mode     = var.client_certificate_mode
  builtin_logging_enabled     = var.builtin_logging_enabled
  tags                        = module.tag_set.tags

  app_settings = merge(
    local.default_application_settings,
    var.function_app_application_settings,
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

  dynamic "site_config" {
    for_each = [var.site_config]
    content {
      always_on                = lookup(site_config.value, "always_on", null)
      app_scale_limit          = lookup(site_config.value, "app_scale_limit", null)
      http2_enabled            = lookup(site_config.value, "http2_enabled", null)
      minimum_tls_version      = lookup(site_config.value, "minimum_tls_version", null)
      elastic_instance_minimum = lookup(site_config.value, "elastic_instance_minimum", null)
      worker_count             = lookup(site_config.value, "worker_count", null)

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

resource "azurerm_windows_function_app" "windows_function" {
  count                       = var.asp_os_type == "Windows" ? 1 : 0
  name                        = "fa-${var.environment}-${var.namespace}-${var.application}"
  service_plan_id             = data.azurerm_service_plan.sp.id
  location                    = var.region
  resource_group_name         = azurerm_resource_group.main.name
  storage_account_name        = var.storage_account_name
  storage_account_access_key  = data.azurerm_storage_account.st_acc.primary_access_key
  functions_extension_version = "~${var.function_app_version}"
  https_only                  = var.https_only
  client_certificate_enabled  = var.client_certificate_enabled
  client_certificate_mode     = var.client_certificate_mode
  builtin_logging_enabled     = var.builtin_logging_enabled
  tags                        = module.tag_set.tags

  app_settings = merge(
    local.default_application_settings,
    var.function_app_application_settings,
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

  dynamic "site_config" {
    for_each = [var.site_config]
    content {
      always_on                = lookup(site_config.value, "always_on", null)
      app_scale_limit          = lookup(site_config.value, "app_scale_limit", null)
      http2_enabled            = lookup(site_config.value, "http2_enabled", null)
      minimum_tls_version      = lookup(site_config.value, "minimum_tls_version", null)
      elastic_instance_minimum = lookup(site_config.value, "elastic_instance_minimum", null)
      worker_count             = lookup(site_config.value, "worker_count", null)

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
    curl -k ${var.functionapp_package} -o app.zip
    az functionapp deployment source config-zip --src app.zip -g ${azurerm_resource_group.main.name} -n ${"fa-${var.environment}-${var.namespace}-${var.application}"}
    rm app.zip
    sleep 60
    EOT
  }
  depends_on = [
    azurerm_linux_function_app.linux_function,
    azurerm_windows_function_app.windows_function
  ]
}

# App Insights
data "azurerm_application_insights" "app_insights" {
  count = var.application_insights_enabled && var.application_insights_name != null ? 1 : 0

  name                = var.application_insights_name
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_application_insights" "app_insights" {
  count = var.application_insights_enabled && var.application_insights_name == null ? 1 : 0

  name                = "ai-${var.environment}-${var.namespace}-${var.application}"
  location            = var.region
  resource_group_name = azurerm_resource_group.main.name
  workspace_id        = var.application_insights_log_analytics_workspace_id
  application_type    = var.application_insights_type
  retention_in_days   = var.application_insights_retention
  tags                = module.tag_set.tags
}

# Logic App
resource "azurerm_resource_group_template_deployment" "terraform-arm" {
  count               = var.logicapp_enabled == true ? 1 : 0
  name                = "lg-${var.environment}-${var.namespace}-${var.application}"
  resource_group_name = azurerm_resource_group.main.name
  template_content    = var.logicapp_template
  parameters_content  = var.logicapp_parameters
  deployment_mode     = "Incremental"
  tags                = module.tag_set.tags
  depends_on = [
    null_resource.functionapp_deploy
  ]
}

resource "azurerm_resource_group_template_deployment" "smtp_api_connection" {
  count               = var.logicapp_enabled == true ? 1 : 0
  name                = "smtp-api-connection"
  resource_group_name = azurerm_resource_group.main.name
  template_content    = var.logicapp_api_connection_template
  parameters_content  = var.logicapp_api_connection_parameters
  deployment_mode     = "Incremental"
  tags                = module.tag_set.tags
}
