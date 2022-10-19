output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = module.functionapp_terratest.resource_group_name
}

output "storage_account_id" {
  description = "The ID of the Storage Account."
  value       = module.functionapp_terratest.storage_account_id
}

output "storage_account_name" {
  description = "The name of the Storage Account"
  value       = module.functionapp_terratest.storage_account_name
}

output "function_app_name" {
  description = "The name of the Function App."
  value       = module.functionapp_terratest.function_app_name
}

output "function_app_id" {
  description = "The ID of the Function App."
  value       = module.functionapp_terratest.function_app_id
}

output "function_app_worker_count" {
  description = "The number of workers of the Function App."
  value       = module.functionapp_terratest.function_app_worker_count
}

output "app_insights_name" {
  description = "The name of the Application Insights component."
  value       = var.application_insights_name != null ? var.application_insights_name : module.functionapp_terratest.app_insights_name
}
