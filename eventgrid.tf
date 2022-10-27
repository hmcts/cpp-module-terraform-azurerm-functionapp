# Topic

resource "azurerm_eventgrid_topic" "function_app_eventgrid" {
  count               = var.eventgrid_topic_enabled == true ? 1 : 0
  name                = "EG-${var.environment}-${var.application}"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = module.tag_set.tags
}

# Subscription

resource "azurerm_storage_queue" "function_app_eventgrid" {
  count                = var.eventgrid_topic_enabled == true ? 1 : 0
  depends_on           = [azurerm_eventgrid_topic.function_app_eventgrid]
  name                 = "fa-${var.environment}-${var.namespace}-${var.application}-astq"
  storage_account_name = var.storage_account_name
}

resource "azurerm_eventgrid_event_subscription" "function_app_eventgrid" {
  count      = var.eventgrid_topic_enabled == true ? 1 : 0
  depends_on = [azurerm_eventgrid_topic.function_app_eventgrid]
  name       = "fa-${var.environment}-${var.namespace}-${var.application}-aees"
  scope      = data.azurerm_resource_group.main.id
  storage_queue_endpoint {
    storage_account_id = azurerm_storage_account.main[count.index]
    queue_name         = azurerm_storage_queue.function_app_eventgrid[count.index].name
  }
}
