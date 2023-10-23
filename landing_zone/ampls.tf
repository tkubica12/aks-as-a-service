// AMPLS
resource "azurerm_monitor_private_link_scope" "main" {
  name                = "ampls"
  resource_group_name = azurerm_resource_group.main.name
}

// AMPLS private endpoint
resource "azurerm_private_endpoint" "ampls" {
  name                = "ampls"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.ampls.id

  private_service_connection {
    name                           = "ampls"
    private_connection_resource_id = azurerm_monitor_private_link_scope.main.id
    subresource_names              = ["azuremonitor"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "zones"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.private_endpoint_zones["privatelink.monitor.azure.com"].id,
      azurerm_private_dns_zone.private_endpoint_zones["privatelink.oms.opinsights.azure.com"].id,
      azurerm_private_dns_zone.private_endpoint_zones["privatelink.ods.opinsights.azure.com"].id,
      azurerm_private_dns_zone.private_endpoint_zones["privatelink.agentsvc.azure-automation.net"].id,
      azurerm_private_dns_zone.private_endpoint_zones["privatelink.blob.core.windows.net"].id,
    ]
  }
}
