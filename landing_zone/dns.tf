locals {
  private_endpoint_zones = [
    "privatelink.monitor.azure.com",
    "privatelink.oms.opinsights.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "privatelink.blob.core.windows.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.agentsvc.azure-automation.net",
    "privatelink.${azurerm_resource_group.main.location}.azmk8s.io",
    "privatelink.${azurerm_resource_group.main.location}.prometheus.monitor.azure.com",
    "privatelink.grafana.azure.com"
  ]
}

resource "azurerm_private_dns_zone" "private_endpoint_zones" {
  for_each            = toset(local.private_endpoint_zones)
  name                = each.key
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_resolver" "main" {
  name                = "resolver"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  virtual_network_id  = azurerm_virtual_network.hub.id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "main" {
  name                    = "resolver-inbound"
  private_dns_resolver_id = azurerm_private_dns_resolver.main.id
  location                = azurerm_private_dns_resolver.main.location

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.dns_in.id
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_endpoint_zones" {
  for_each              = toset(local.private_endpoint_zones)
  name                  = each.key
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.private_endpoint_zones[each.key].name
  virtual_network_id    = azurerm_virtual_network.hub.id
}

