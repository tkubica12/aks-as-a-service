output "cluster_id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "cluster_identity_principal_id" {
  value = azurerm_user_assigned_identity.aks_cluster.principal_id
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.main.oidc_issuer_url
}

output "shared_identity_client_id" {
  value = azurerm_user_assigned_identity.shared_identity.client_id
}

output "shared_keyvault_name" {
  value = azurerm_key_vault.system.name
}