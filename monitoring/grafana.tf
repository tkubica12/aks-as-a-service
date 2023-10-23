// Azure Managed Grafana
resource "azurerm_dashboard_grafana" "main" {
  name                              = var.grafana_name
  resource_group_name               = azurerm_resource_group.main.name
  location                          = azurerm_resource_group.main.location
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = false
  zone_redundancy_enabled           = true

  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.main.id
  }

  identity {
    type = "SystemAssigned"
  }
}

// Azure Managed Grafana Private Endpoint
resource "azurerm_private_endpoint" "grafana" {
  name                = "grafana-pe"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = var.monitor_subnet_id

  private_service_connection {
    name                           = "grafana"
    private_connection_resource_id = azurerm_dashboard_grafana.main.id
    subresource_names              = ["grafana"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "zones"
    private_dns_zone_ids = [
      var.grafana_zone_id
    ]
  }
}

// Monitor Data Reader for Azure Managed Grafana to access Azure Monitor Workspace
resource "azurerm_role_assignment" "datareaderrole" {
  scope                = azurerm_monitor_workspace.main.id
  role_definition_name = "Monitoring Data Reader"
  principal_id         = azurerm_dashboard_grafana.main.identity.0.principal_id
}
