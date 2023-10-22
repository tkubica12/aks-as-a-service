// Azure Monitor Workspace - will be used as backend for Prometheus metrics
resource "azurerm_monitor_workspace" "main" {
  name                = var.monitor_workspace_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
}

// Data Collection Endpoint
resource "azurerm_monitor_data_collection_endpoint" "main" {
  name                = "aks-prometheus"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  kind                = "Linux"
}

resource "azurerm_monitor_private_link_scoped_service" "main" {
  name                = "aks-prometheus"
  resource_group_name = var.ampls_rg_name
  scope_name          = var.ampls_name
  linked_resource_id  = azurerm_monitor_data_collection_endpoint.main.id
}

# resource "azurerm_monitor_data_collection_rule" "dcr" {
#   name                        = "MSProm-${azurerm_resource_group.rg.location}-${var.cluster_name}"
#   resource_group_name         = azurerm_resource_group.rg.name
#   location                    = azurerm_resource_group.rg.location
#   data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.dce.id
#   kind                        = "Linux"

#   destinations {
#     monitor_account {
#       monitor_account_id = azurerm_monitor_workspace.amw.id
#       name               = "MonitoringAccount1"
#     }
#   }

#   data_flow {
#     streams      = ["Microsoft-PrometheusMetrics"]
#     destinations = ["MonitoringAccount1"]
#   }


#   data_sources {
#     prometheus_forwarder {
#       streams = ["Microsoft-PrometheusMetrics"]
#       name    = "PrometheusDataSource"
#     }
#   }

#   description = "DCR for Azure Monitor Metrics Profile (Managed Prometheus)"
#   depends_on = [
#     azurerm_monitor_data_collection_endpoint.dce
#   ]
# }

# resource "azurerm_monitor_data_collection_rule_association" "dcra" {
#   name                    = "MSProm-${azurerm_resource_group.rg.location}-${var.cluster_name}"
#   target_resource_id      = azurerm_kubernetes_cluster.k8s.id
#   data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr.id
#   description             = "Association of data collection rule. Deleting this association will break the data collection for this AKS Cluster."
#   depends_on = [
#     azurerm_monitor_data_collection_rule.dcr
#   ]
# }

