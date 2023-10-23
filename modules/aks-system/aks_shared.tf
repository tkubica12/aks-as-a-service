// Provision one or more shared nodepools
resource "azurerm_kubernetes_cluster_node_pool" "shared" {
  for_each               = var.shared_nodepools
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
  os_sku                 = "AzureLinux"

  node_labels = {
    "dedication" = "shared"
  }

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
}

// Managed Identity for shared components
resource "azurerm_user_assigned_identity" "shared_identity" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = {}
}

// RBAC - shared components identity to get read access to Key Vault secrets
resource "azurerm_role_assignment" "shared_identity" {
  scope                = azurerm_key_vault.system.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.shared_identity.principal_id
}

// Federate managed identity with Kubernetes OIDC
resource "azurerm_federated_identity_credential" "shared_identity" {
  name                = "system-secrets-reader"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.main.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.shared_identity.id
  subject             = "system:serviceaccount:shared-components:shared"
}
