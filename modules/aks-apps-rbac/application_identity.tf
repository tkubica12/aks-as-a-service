// Managed Identity for each application to read secrets
resource "azurerm_user_assigned_identity" "application_identity" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = {}
}

// RBAC - application identity to get read access to Key Vault secrets
resource "azurerm_role_assignment" "application_identity" {
  scope                = azurerm_key_vault.application.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.application_identity.principal_id
}

// Federate managed identity with Kubernetes OIDC
resource "azurerm_federated_identity_credential" "application_identity" {
  name                = "${var.name}-secrets-reader"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.application_identity.id
  subject             = "system:serviceaccount:${var.name}:application"
}
