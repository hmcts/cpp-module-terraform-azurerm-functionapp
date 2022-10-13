module "functionapp_terratest" {
  source                                    = "../../"
  storage_account_name                      = var.storage_account_name
  region                                    = var.region
  storage_account_tier                      = var.storage_account_tier
  storage_account_kind                      = var.storage_account_kind
  storage_account_account_replication_type  = var.storage_account_account_replication_type
  storage_account_min_tls_version           = var.storage_account_min_tls_version
  storage_account_enable_https_traffic_only = var.storage_account_enable_https_traffic_only
  storage_account_identity_type             = var.storage_account_identity_type
  storage_account_identity_ids              = var.storage_account_identity_ids
  asp_os_type                               = var.asp_os_type
  asp_instance_size                         = var.asp_instance_size
  function_app_application_settings         = var.function_app_application_settings
  functionapp_package                       = var.functionapp_package
  site_config                               = var.site_config
  application_insights_enabled              = var.application_insights_enabled

  namespace   = var.namespace
  costcode    = var.costcode
  attribute   = var.attribute
  owner       = var.owner
  environment = var.environment
  application = var.application
  type        = var.type
}
