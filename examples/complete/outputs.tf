output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = module.functionapp_terratest.resource_group_name
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
