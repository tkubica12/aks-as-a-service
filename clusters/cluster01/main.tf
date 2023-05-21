locals {
  manifest = yamldecode(file("manifest.yaml"))
}

resource "azurerm_resource_group" "main" {
  name     = local.manifest.resource_group_name
  location = local.manifest.location
}

module "aks" {
  source              = "../.."
  manifest            = local.manifest
  resource_group_name = azurerm_resource_group.main.name
  resource_group_id   = azurerm_resource_group.main.id
  location            = azurerm_resource_group.main.location
}
