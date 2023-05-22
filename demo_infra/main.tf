resource "azurerm_resource_group" "main" {
  name     = "demo-infra"
  location = "northeurope"
}

data "azurerm_client_config" "current" {}
