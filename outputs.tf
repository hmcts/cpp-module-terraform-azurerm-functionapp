output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = var.create_function_app ? (var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.resource_group_name : azurerm_windows_function_app.windows_function.0.resource_group_name) : var.resource_group_name
}

output "function_app_name" {
  description = "The name of the Function App."
  value       = var.create_function_app ? (var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.name : azurerm_windows_function_app.windows_function.0.name) : null
}

output "function_app_id" {
  description = "The ID of the Function App."
  value       = var.create_function_app ? (var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.id : azurerm_windows_function_app.windows_function.0.id) : null
}

output "function_app_worker_count" {
  description = "The number of workers of the Function App."
  value       = var.create_function_app ? (var.asp_os_type == "Linux" ? lookup(azurerm_linux_function_app.linux_function.0.site_config[0], "worker_count", null) : lookup(azurerm_windows_function_app.windows_function.0.site_config[0], "worker_count", null)) : null
}

output "function_app_primary_key" {
  description = "Primary Key for Function App"
  value       = var.create_function_app ? data.azurerm_function_app_host_keys.main.0.primary_key : null
  sensitive   = true
}

output "principal_id" {
  description = "Principal ID of the Function APP"
  value       = var.create_function_app && var.identity != {} ? (var.asp_os_type == "Linux" ? azurerm_linux_function_app.linux_function.0.identity.0.principal_id : azurerm_windows_function_app.windows_function.0.identity.0.principal_id) : null
}

output "service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = var.create_service_plan ? azurerm_service_plan.main.0.id : data.azurerm_service_plan.sp.id
}

output "service_plan_name" {
  description = "The name of the App Service Plan"
  value       = var.service_plan_name
}
