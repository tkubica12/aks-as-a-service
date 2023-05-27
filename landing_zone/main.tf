resource "azurerm_resource_group" "main" {
  name     = "aks-as-a-service-lz"
  location = var.location
}

data "azurerm_client_config" "current" {}
