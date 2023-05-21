// Generate name for Key Vault
resource "random_string" "main" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  numeric = false
}

data "azurerm_client_config" "current" {}