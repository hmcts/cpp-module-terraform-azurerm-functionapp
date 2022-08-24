output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = azurerm_resource_group.main.name
}

output "storage_account_id" {
  description = "The ID of the Storage Account."
  value       = azurerm_storage_account.main.0.id
}

output "storage_account_name" {
  description = "The name of the Storage Account"
  value       = azurerm_storage_account.main.0.name
}

output "function_app_name" {
  description = "The name of the Function App."
  value       = azurerm_linux_function_app.linux_function.name
}

output "function_app_id" {
  description = "The ID of the Function App."
  value       = azurerm_linux_function_app.linux_function.id
}

output "function_app_worker_count" {
  description = "The number of workers of the Function App."
  value       = lookup(azurerm_linux_function_app.linux_function.site_config[0], "worker_count", null)
}

output "app_insights_id" {
  description = "The ID of the Application Insights component."
  value       = azurerm_application_insights.app_insights.0.id
}

output "app_insights_instrumentation_key" {
  description = "The instrumentation key of the Application Insights component."
  value       = azurerm_application_insights.app_insights.0.instrumentation_key
  sensitive   = true
}
