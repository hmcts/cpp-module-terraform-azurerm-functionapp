terraform {

  required_version = ">=1.2.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.103.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "=2.21.0"
    }
  }
}
