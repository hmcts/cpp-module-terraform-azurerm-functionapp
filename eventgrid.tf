# Standard Topic
resource "azurerm_eventgrid_topic" "function_app_eventgrid_topic" {
  count               = var.eventgrid_topic_enabled == true ? 1 : 0
  name                = "EG-${var.environment}-${var.application}"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = module.tag_set.tags
}

# Standard Topic Subscription
resource "azurerm_eventgrid_event_subscription" "function_app_eventgrid_topic" {
  depends_on = [azurerm_eventgrid_topic.function_app_eventgrid_topic, azurerm_windows_function_app.windows_function, azurerm_linux_function_app.linux_function]
  name       = "EGS-${var.environment}-${var.namespace}-${var.application}"
  scope      = data.azurerm_resource_group.main.id
  azure_function_endpoint {
    function_id = length(azurerm_windows_function_app.windows_function) == 1 ? azurerm_windows_function_app.windows_function[0].id : azurerm_linux_function_app.linux_function[0].id
  }
  for_each = var.eventgrid_topic_subscriptions
}

# System Topic
resource "azurerm_eventgrid_system_topic" "function_app_eventgrid_system_topic" {
  count                  = var.eventgrid_system_topic_enabled == true ? 1 : 0
  name                   = "EGST-${var.environment}-${var.application}"
  resource_group_name    = data.azurerm_resource_group.main.name
  location               = var.region
  source_arm_resource_id = azurerm_storage_account.main[count.index].id
  topic_type             = var.eventgrid_system_topic_enabled
}

# System Topic Subscription
resource "azurerm_eventgrid_event_subscription" "function_app_eventgrid_system_topic" {
  depends_on = [azurerm_eventgrid_system_topic.function_app_eventgrid_system_topic, azurerm_windows_function_app.windows_function, azurerm_linux_function_app.linux_function]
  name       = "EGSTS-${var.environment}-${var.namespace}-${var.application}"
  scope      = data.azurerm_resource_group.main.id
  azure_function_endpoint {
    function_id = length(azurerm_windows_function_app.windows_function) == 1 ? azurerm_windows_function_app.windows_function[0].id : azurerm_linux_function_app.linux_function[0].id
  }
  for_each = var.eventgrid_system_topic_subscriptions
}
