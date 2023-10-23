resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

// Current user
data "azurerm_client_config" "current" {}