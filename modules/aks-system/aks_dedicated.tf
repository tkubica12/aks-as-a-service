// Provision dedicated nodepool for each confidential application
resource "azurerm_kubernetes_cluster_node_pool" "dedicated" {
  for_each               = var.confidential_applications
  name                   = each.key
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.main.id
  vm_size                = each.value.node_sku
  node_count             = each.value.node_count
  min_count              = each.value.min_count
  max_count              = each.value.max_count
  enable_host_encryption = true
  vnet_subnet_id         = each.value.subnet_id
  enable_auto_scaling    = true
  zones                  = [1, 2, 3]

  node_labels = {
    "dedication" = each.key
  }

  node_taints = [
    "dedication=${each.key}:NoSchedule"
  ]

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
}
