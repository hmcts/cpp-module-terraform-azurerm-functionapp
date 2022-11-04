output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.resource_group_name : azurerm_windows_function_app.windows_function.0.resource_group_name
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

output "function_app_primary_key" {
  description = "Primary Key for Function App"
  value       = data.azurerm_function_app_host_keys.main.primary_key
}
