output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = data.azurerm_resource_group.main.name
}

output "storage_account_id" {
  description = "The ID of the Storage Account."
  value       = data.azurerm_storage_account.st_acc.id
}

output "storage_account_name" {
  description = "The name of the Storage Account"
  value       = data.azurerm_storage_account.st_acc.name
}

output "function_app_name" {
  description = "The name of the Function App."
  value       = var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.name : azurerm_windows_function_app.windows_function.0.name
}

output "function_app_id" {
  description = "The ID of the Function App."
  value       = var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.id : azurerm_windows_function_app.windows_function.0.id
}

output "function_app_worker_count" {
  description = "The number of workers of the Function App."
  value       = var.asp_os_type == "Linux" ? lookup(azurerm_linux_function_app.linux_function.0.site_config[0], "worker_count", null) : lookup(azurerm_windows_function_app.windows_function.0.site_config[0], "worker_count", null)
}

output "app_insights_name" {
  description = "The name of the Application Insights component."
  value       = var.application_insights_name != null ? var.application_insights_name : azurerm_application_insights.app_insights.0.id
}
