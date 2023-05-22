// Wait for RBAC and private changes changes to propagate so Terraform can create keys via private endpoint
resource "time_sleep" "wait" {
  create_duration = "60s"

  depends_on = [
    azurerm_role_assignment.system_kv,
    azurerm_private_endpoint.keyvault_system
  ]
}

// Key for system disk encryption
resource "azurerm_key_vault_key" "system_storage" {
  name         = "system-storage"
  key_vault_id = azurerm_key_vault.system.id
  key_type     = "RSA"
  key_size     = 2048

  depends_on = [
    azurerm_role_assignment.system_kv,
    azurerm_private_endpoint.keyvault_system,
    time_sleep.wait
  ]

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

// Key for Etcd encryption (KMS)
resource "azurerm_key_vault_key" "kms" {
  name         = "kms"
  key_vault_id = azurerm_key_vault.system.id
  key_type     = "RSA"
  key_size     = 2048

  depends_on = [
    azurerm_role_assignment.system_kv,
    azurerm_private_endpoint.keyvault_system,
    time_sleep.wait
  ]

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

// Disk Encpryption Set for system disk
resource "azurerm_disk_encryption_set" "system" {
  name                = "system"
  location            = var.location
  resource_group_name = var.resource_group_name
  key_vault_key_id    = azurerm_key_vault_key.system_storage.id

  identity {
    type = "SystemAssigned"
  }
}

// RBAC - identity of Disk Encrpyption Set to use crypto services in Key Vault
resource "azurerm_role_assignment" "system_disk_encryption_set" {
  scope                = azurerm_key_vault.system.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.system.identity.0.principal_id
}

// RBAC - cluster identity to use Keys in Key Vault for host encryption
resource "azurerm_role_assignment" "aks_cluster_crypto_user" {
  scope                = azurerm_key_vault.system.id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_user_assigned_identity.aks_cluster.principal_id
}



