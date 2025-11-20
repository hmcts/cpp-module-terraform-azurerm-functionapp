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

variable "enable_autoscale" {
  description = " If true a scaling rule is configured"
  type        = bool
  default     = false
}

variable "create_function_app" {
  description = "If true, creates the Function App. Set to false to deploy only the App Service Plan."
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

variable "asp_maximum_elastic_worker_count" {
  description = "Max burst size"
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
  type        = string
  description = "Name of the Function App"
  default     = null
}

variable "function_app_version" {
  description = "Version of the function app runtime to use (Allowed values 2, 3 or 4)"
  type        = number
  default     = 4
}

variable "storage_account_name" {
  type        = string
  description = "Storage account to associate with function app"
  default     = ""
}

variable "public_network_access_override" {
  type        = bool
  description = "Override the default logic of enabling public access only on non-private endpoint SKUs"
  default     = true
}

variable "storage_account_access_key" {
  type        = string
  description = "Storage account access key to be used by function app"
  default     = null
  sensitive   = true
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

variable "autoscale_config" {
  description = "if autoscale is enabled for app service plan, required configuration to be passed"
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

variable "private_endpoint_skus" {
  type    = list(any)
  default = ["EP1", "EP2", "EP3", "FC1"]
}

variable "private_endpoint" {
  type        = string
  description = "Name of private endpoint"
  default     = ""
}

variable "private_service_connection" {
  type        = string
  description = "Name for private service connection"
  default     = "test"
}

variable "private_dns_zone_name" {
  type        = string
  description = "Name for private dns zone"
  default     = "privatelink.azurewebsites.net"
}

variable "dns_link" {
  type        = string
  description = "Name of DNS link connecting private DNS zone to VNet"
  default     = ""
}

variable "dns_resource_group_name" {
  type        = string
  description = "Name of private DNS zone resource group"
  default     = ""
}

variable "subnet_cidr" {
  description = "Vnet Subnet CIDR"
  type        = list(string)
  default     = []
}

variable "subnet_ingress_cidr" {
  description = "Vnet Subnet CIDR for PEs"
  type        = list(string)
  default     = []
}

variable "subnet_id" {
  description = "Subnet ID to use"
  type        = string
  default     = null
}

variable "subnet_ingress_id" {
  description = "Subnet ID to use for PE"
  type        = string
  default     = null
}

variable "create_subnet" {
  description = "Should Create Subnet"
  type        = bool
  default     = false
}

variable "create_ingress_subnet" {
  description = "Should Create Subnet for PE"
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
