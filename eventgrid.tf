# Topic

resource "azurerm_eventgrid_topic" "function_app" {
  count               = var.eventgrid_topic_enabled == true ? 1 : 0
  name                = "topic-${var.application}"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = module.tag_set.tags
}

# Subscription

resource "azurerm_storage_account" "function_app" {
  depends_on               = [azurerm_eventgrid_topic.function_app]
  name                     = "fa-${var.application}-asa"
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = module.tag_set.tags
}

resource "azurerm_storage_queue" "function_app" {
  depends_on           = [azurerm_eventgrid_topic.function_app]
  name                 = "fa-${var.application}-astq"
  storage_account_name = azurerm_storage_account.function_app.name
}

resource "azurerm_eventgrid_event_subscription" "function_app" {
  depends_on = [azurerm_eventgrid_topic.function_app]
  name       = "fa-${var.application}-aees"
  scope      = data.azurerm_resource_group.main.id
  storage_queue_endpoint {
    storage_account_id = azurerm_storage_account.function_app.id
    queue_name         = azurerm_storage_queue.function_app.name
  }
}
