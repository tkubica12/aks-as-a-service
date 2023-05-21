// Key for storage encryption
resource "azurerm_key_vault_key" "application_storage" {
  name         = "${var.name}-storage"
  key_vault_id = azurerm_key_vault.application.id
  key_type     = "RSA"
  key_size     = 2048

  depends_on = [
    azurerm_role_assignment.application_kv,
    azurerm_private_endpoint.keyvault_application
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

//  Disk Encpryption Set for app disks
resource "azurerm_disk_encryption_set" "application" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  key_vault_key_id    = azurerm_key_vault_key.application_storage.id

  identity {
    type = "SystemAssigned"
  }
}

// RBAC - identity of Disk Encrpyption Set to use crypto services in Key Vault
resource "azurerm_role_assignment" "application_disk_encryption_set" {
  scope                = azurerm_key_vault.application.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.application.identity.0.principal_id
}



