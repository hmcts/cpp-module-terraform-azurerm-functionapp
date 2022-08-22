storage_account_name                      = "salabfa01"
resource_group_name                       = "RG-LAB-FA-01"
storage_account_kind                      = "StorageV2"
storage_account_tier                      = "Standard"
storage_account_min_tls_version           = "TLS1_2"
storage_account_enable_https_traffic_only = true
storage_account_identity_type             = "SystemAssigned"
storage_account_identity_ids              = null
storage_account_account_replication_type  = "LRS"
asp_name                                  = "my_asp_name"
asp_os_type                               = "Linux"
asp_instance_size                         = 2
function_app_name                         = "fa-lab-fa-01"
function_app_application_settings = {
  WEBSITE_NODE_DEFAULT_VERSION = "~14"
}
site_config = {
  minimum_tls_version = "1.2"
  worker_count        = 2
  application_stack = {
    node_version = 14
  }
}
application_zip_package_path = "path/to/zip_pkg"
app_insights_name            = "ai-lab-fa-01"
application_insights_enabled = true

namespace   = "cpp"
costcode    = "terratest"
attribute   = ""
owner       = "EI"
environment = "nonlive"
application = "atlassian"
type        = "functionapp"
