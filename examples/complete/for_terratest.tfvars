asp_sku                      = "EP1"
asp_os_type                  = "Windows"
asp_instance_size            = 1
asp_per_site_scaling_enabled = false
asp_zone_balancing_enabled   = false

application_settings = {
  FUNCTIONS_EXTENSION_VERSION        = "~2"
  ENABLE_ORYX_BUILD                  = false
  SCM_DO_BUILD_DURING_DEPLOYMENT     = false
  FUNCTIONS_WORKER_RUNTIME           = "java"
  WEBSITE_HTTPLOGGING_RETENTION_DAYS = 3
}
site_config = {
  use_32_bit_worker_process = true
}
resource_group_name  = "rg-lab-cpp-faterratest"
function_app_name    = "fa-lab-cpp-faterratest"
service_plan_name    = "as-lab-cpp-faterratest"
storage_account_name = "salabcppfaterratest"
create_service_plan  = true

location            = "uksouth"
namespace           = "cpp"
costcode            = "terratest"
attribute           = ""
owner               = "EI"
environment         = "nonlive"
application         = "test"
type                = "functionapp"
vnet_name           = "vnet-lab-cpp-faterratest"
vnet_rg_name        = "rg-lab-cpp-faterratest"
subnet_ingress_name = "functionapp-faterratest"
vnet_cidr           = ["10.0.0.0/16"]
subnet_cidr         = ["10.0.1.0/24"]
subnet_ingress_cidr = ["10.0.2.0/24"]
private_endpoint    = "test-lab-terratest-private-endpoint"
