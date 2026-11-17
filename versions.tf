terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # azurerm 5.x removed service_endpoints from azurerm_subnet; consumers pin 3.103.1 and 4.18.0
      version = ">= 3.103.1, < 5.0.0"
    }
  }
}
