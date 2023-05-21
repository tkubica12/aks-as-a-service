// RBAC - Grant reader roles to namespace
resource "azurerm_role_assignment" "readers" {
  for_each             = var.permanent_readers
  scope                = "${var.cluster_id}/namespaces/${var.namespace}"
  role_definition_name = "Azure Kubernetes Service RBAC Reader"
  principal_id         = each.value.object_id
}

// RBAC - Grant writer roles to namespace
resource "azurerm_role_assignment" "writers" {
  for_each             = var.permanent_writers
  scope                = "${var.cluster_id}/namespaces/${var.namespace}"
  role_definition_name = "Azure Kubernetes Service RBAC Writer"
  principal_id         = each.value.object_id
}

