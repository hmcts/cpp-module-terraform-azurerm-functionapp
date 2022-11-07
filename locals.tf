locals {
  application_settings_sensitive_keyvault_lookup        = { for k, v in data.azurerm_key_vault_secret.main : k => v.value }
  application_settings_sensitive_hashicorp_vault_lookup = { for k, v in data.vault_generic_secret.main : k => v.data.value }
}
