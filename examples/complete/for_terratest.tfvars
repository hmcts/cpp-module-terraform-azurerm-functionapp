storage_account_name                      = "salabfa01"
storage_account_kind                      = "StorageV2"
storage_account_tier                      = "Standard"
storage_account_min_tls_version           = "TLS1_2"
storage_account_enable_https_traffic_only = true
storage_account_identity_type             = "SystemAssigned"
storage_account_identity_ids              = null
storage_account_account_replication_type  = "LRS"
asp_os_type                               = "Linux"
asp_instance_size                         = 2

functionapp_package = "https://libraries-internal.mdv.cpp.nonlive/artifactory/list/repocentral/uk/gov/moj/cpp/notification/notify/notificationnotify-azure-functions/8.0.2/notificationnotify-azure-functions-8.0.2.zip"
function_app_application_settings = {
  WEBSITE_NODE_DEFAULT_VERSION = "~14"
}
site_config = {
  minimum_tls_version = "1.2"
  worker_count        = 2
  application_stack = {
    node_version = "14"
  }
}
app_insights_name            = "ai-lab-fa-01"
application_insights_enabled = true

namespace   = "cpp"
costcode    = "terratest"
attribute   = ""
owner       = "EI"
environment = "nonlive"
application = "atlassian"
type        = "functionapp"
