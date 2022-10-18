############
# DEFAULTS #
############

variable "region" {
  type    = string
  default = "uksouth"
}

###################
# STORAGE ACCOUNT #
###################

variable "storage_account_name" {
  description = "Storage Account Name"
  type        = string
  default     = null
}

variable "create_storage_account" {
  description = " If true a new storage account is created"
  type        = bool
  default     = true
}

variable "create_service_plan" {
  description = " If true a new service plan is created"
  type        = bool
  default     = true
}

variable "service_plan_name" {
  description = "Service Plan Name"
  type        = string
  default     = null
}

variable "storage_account_tier" {
  description = "Storage Account Tier"
  type        = string
  default     = "Standard"
}

variable "storage_account_kind" {
  description = "Storage Account Kind"
  type        = string
  default     = "StorageV2"
}

variable "storage_account_account_replication_type" {
  description = "Storage Account Replication Type"
  type        = string
  default     = "LRS"
}

variable "storage_account_min_tls_version" {
  description = "Storage Account minimal TLS version"
  type        = string
  default     = "TLS1_2"
}

variable "storage_account_enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled, see [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information."
  type        = bool
  default     = false
}

variable "storage_account_enable_https_traffic_only" {
  description = "Boolean flag which controls if https traffic only is enabled."
  type        = bool
  default     = true
}

variable "storage_account_identity_type" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Storage Account"
  type        = string
  default     = null
}

variable "storage_account_identity_ids" {
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account"
  type        = list(string)
  default     = null
}

variable "storage_account_network_rules_enabled" {
  description = "Enable Storage account network default rules for functions"
  type        = bool
  default     = true
}

variable "storage_account_network_bypass" {
  description = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of `Logging`, `Metrics`, `AzureServices`, or `None`."
  type        = list(string)
  default     = ["Logging", "Metrics", "AzureServices"]
}

variable "storage_account_authorized_ips" {
  description = "IPs restriction for Function storage account in CIDR format"
  type        = list(string)
  default     = []
}

####################
# APP SERVICE PLAN #
####################
variable "asp_sku" {
  description = "SKU of the App Service Plan for Function App hosting"
  type        = string
  default     = "S1"
}

variable "asp_os_type" {
  description = "OS of the App Service Plan for Function App hosting"
  type        = string
}

variable "asp_instance_size" {
  description = "The number of Workers (instances) to be allocated to the ASP"
  type        = number
  default     = 1
}

variable "asp_per_site_scaling_enabled" {
  description = "Should Per Site Scaling be enabled"
  type        = bool
  default     = false
}

variable "asp_zone_balancing_enabled" {
  description = "Should the Service Plan balance across Availability Zones in the region"
  type        = bool
  default     = false
}

###############
# FUNCTIONAPP #
###############

variable "function_app_version" {
  description = "Version of the function app runtime to use (Allowed values 2, 3 or 4)"
  type        = number
  default     = 4
}

variable "functionapp_package" {
  description = "The ZIP file location of the functionapp package"
  type        = string
}

variable "function_app_application_settings" {
  description = "Function App application settings"
  type        = map(string)
  default     = {}
}

variable "site_config" {
  description = "Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is not managed in this block."
  type        = any
  default     = {}
}

variable "https_only" {
  description = "Disable http procotol and keep only https"
  type        = bool
  default     = true
}

variable "builtin_logging_enabled" {
  description = "Should built in logging be enabled"
  type        = bool
  default     = true
}

variable "client_certificate_enabled" {
  description = "Should the function app use Client Certificates"
  type        = bool
  default     = null
}

variable "client_certificate_mode" {
  description = "(Optional) The mode of the Function App's client certificates requirement for incoming requests. Possible values are `Required`, `Optional`, and `OptionalInteractiveUser`."
  type        = string
  default     = null
}

# variable "function_app_vnet_integration_enabled" {
#   description = "Enable VNET integration with the Function App. `function_app_vnet_integration_subnet_id` is mandatory if enabled"
#   type        = bool
#   default     = false
# }

# variable "function_app_vnet_integration_subnet_id" {
#   description = "ID of the subnet to associate with the Function App (VNet integration)"
#   type        = string
#   default     = null
# }

################
# APP INSIGHTS #
################

variable "application_insights_enabled" {
  description = "Enable or disable the Application Insights deployment"
  type        = bool
  default     = true
}

variable "application_insights_id" {
  description = "ID of the existing Application Insights to use instead of deploying a new one."
  type        = string
  default     = null
}

variable "application_insights_log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace to be used with Application Insights"
  type        = string
  default     = null
}

variable "application_insights_type" {
  description = "Application Insights type if need to be generated. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights#application_type"
  type        = string
  default     = "web"
}

variable "application_insights_retention" {
  description = "Specify retention period (in days) for logs"
  type        = number
  default     = 90
}

#############
# LOGIC APP #
#############

variable "logicapp_enabled" {
  description = "Enable or disable a Logic App deployment"
  type        = bool
  default     = false
}

variable "logicapp_template" {
  description = "The ARM template of the Logic App deployment"
  type        = string
  default     = null
}

variable "logicapp_parameters" {
  description = "The Logic App ARM template parameters"
  type        = string
  default     = null
}

variable "logicapp_api_connection_template" {
  description = "The ARM template of the Logic App api connection deployment"
  type        = string
  default     = null
}

variable "logicapp_api_connection_parameters" {
  description = "The Logic App api connection ARM template parameters"
  type        = string
  default     = null
}

############
# TAGGING  #
############

variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be an organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "costcode" {
  type        = string
  description = "Name of theDWP PRJ number (obtained from the project portfolio in TechNow)"
  default     = ""
}

variable "owner" {
  type        = string
  description = "Name of the project or sqaud within the PDU which manages the resource. May be a persons name or email also"
  default     = ""
}

variable "version_number" {
  type        = string
  description = "The version of the application or object being deployed. This could be a build object or other artefact which is appended by a CI/Cd platform as part of a process of standing up an environment"
  default     = ""
}

variable "application" {
  type        = string
  description = "Application to which the s3 bucket relates"
  default     = ""
}

variable "application_group" {
  type        = string
  description = "Application to which the s3 bucket relates"
  default     = ""
}

variable "attribute" {
  type        = string
  description = "An attribute of the s3 bucket that makes it unique"
  default     = ""
}

variable "environment" {
  type        = string
  description = "Environment into which resource is deployed"
  default     = ""
}

variable "type" {
  type        = string
  description = "Name of service type"
  default     = ""
}
