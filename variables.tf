variable "location" {
  type    = string
  default = "uksouth"
}

variable "resource_group_name" {
  type = string
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
  description = "Should the Service Plan balance across Availability Zones in the location"
  type        = bool
  default     = false
}

variable "function_app_name" {
  type = string
}

variable "function_app_version" {
  description = "Version of the function app runtime to use (Allowed values 2, 3 or 4)"
  type        = number
  default     = 4
}

variable "functionapp_package" {
  description = "The ZIP file location of the functionapp package"
  type        = string
}

variable "application_settings" {
  description = "Function App application settings"
  type        = map(string)
  default     = {}
}

variable "application_settings_sensitive_keyvault_lookup" {
  description = "Function App application settings lookup from keyvault"
  type        = map(string)
  default     = {}
}

variable "application_settings_sensitive_hashicorp_vault_lookup" {
  description = "Function App application settings lookup from Hashicorp vault"
  type        = map(string)
  default     = {}
}

variable "storage_account_name" {
  type        = string
  description = "Storage account to associate with function app"
}

variable "storage_account_access_key" {
  type        = string
  description = "Storage account access key to be used by function app"
}

variable "key_vault_id" {
  type        = string
  description = "keyvault id to lookup secret settings"
  default     = null
}

variable "site_config" {
  description = "Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is not managed in this block."
  type        = any
  default     = {}
}

variable "identity" {
  description = "Identity block Specifies the identity to assign to function app"
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

variable "tags" {
  type    = map(string)
  default = {}
}


variable "vnet_name" {
  description = "Vnet Name for Private Subnets"
  type        = string
  default     = ""
}

variable "vnet_rg_name" {
  description = "Vnet Resource Group Name for Private Subnets"
  type        = string
  default     = ""
}

variable "subnet_cidr" {
  description = "Vnet Subnet CIDR"
  type        = list(string)
  default     = []
}

variable "subnet_name" {
  description = "Subnet Name to reuse"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Subnet ID to use"
  type        = string
  default     = ""
}

variable "create_subnet" {
  description = "Should Create Subnet"
  type        = bool
  default     = false
}

variable "environment" {
  type        = string
  description = "Environment into which resource is deployed"
  default     = ""
}

variable "cert_contents" {
  type        = map(string)
  description = "Root ca cert content"
  default     = {}
}

variable "storage_account" {
  description = "storage account to mount"
  type        = any
  default     = {}
}
