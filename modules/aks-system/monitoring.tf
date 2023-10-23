// Association of AKS cluster with DCE for Prometheus collection
resource "azurerm_monitor_data_collection_rule_association" "dcra" {
  count              = var.prometheus_dce_id != "" ? 1 : 0
  name               = var.name
  target_resource_id = azurerm_kubernetes_cluster.main.id
  #   data_collection_endpoint_id = var.prometheus_dce_id
  data_collection_rule_id = var.prometheus_dcr_id
  description             = "Association of data collection rule. Deleting this association will break the data collection for this AKS Cluster."
}
