module "tag_set" {
  source         = "git::https://github.com/hmcts/cpp-module-terraform-azurerm-tag-generator.git?ref=main"
  namespace      = var.namespace
  application    = var.application
  costcode       = var.costcode
  owner          = var.owner
  version_number = var.version_number
  attribute      = var.attribute
  environment    = var.environment
  type           = var.type
}

resource "azurerm_resource_group" "test" {
  name     = var.resource_group_name
  location = var.location
  tags     = module.tag_set.tags
}

resource "azurerm_virtual_network" "test" {
  name                = var.vnet_name
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "test"
    address_prefix = "10.0.1.0/24"
  }

  tags = module.tag_set.tags
}

resource "azurerm_storage_account" "test" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.test.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "test"
  }
}

module "functionapp_terratest" {
  source                       = "../../"
  location                     = var.location
  function_app_name            = var.function_app_name
  resource_group_name          = azurerm_resource_group.test.name
  asp_os_type                  = var.asp_os_type
  asp_instance_size            = var.asp_instance_size
  asp_sku                      = var.asp_sku
  asp_per_site_scaling_enabled = var.asp_per_site_scaling_enabled
  asp_zone_balancing_enabled   = var.asp_zone_balancing_enabled
  application_settings         = var.application_settings
  functionapp_package          = var.functionapp_package
  site_config                  = var.site_config
  service_plan_name            = var.service_plan_name
  storage_account_name         = var.storage_account_name
  storage_account_access_key   = azurerm_storage_account.test.primary_access_key
  create_service_plan          = var.create_service_plan
  tags                         = module.tag_set.tags
  vnet_name                    = var.vnet_name
  vnet_rg_name                 = var.vnet_rg_name
}
