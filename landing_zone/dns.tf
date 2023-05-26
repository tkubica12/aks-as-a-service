resource "azurerm_private_dns_zone" "northeurope" {
  name                = "privatelink.northeurope.azmk8s.io"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_resolver" "main" {
  count               = var.enable_vpn ? 1 : 0
  name                = "resolver"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  virtual_network_id  = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "main" {
  count                   = var.enable_vpn ? 1 : 0
  name                    = "resolver-inbound"
  private_dns_resolver_id = azurerm_private_dns_resolver.main[0].id
  location                = azurerm_private_dns_resolver.main[0].location

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.dns_in.id
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks_hub" {
  name                  = "aks-hub"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.northeurope.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks_cluster01b" {
  name                  = "aks-cluster01"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.northeurope.name
  virtual_network_id    = azurerm_virtual_network.cluster01.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv_hub" {
  name                  = "kv-hub"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv_cluster01" {
  name                  = "kv-cluster01"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = azurerm_virtual_network.cluster01.id
}
