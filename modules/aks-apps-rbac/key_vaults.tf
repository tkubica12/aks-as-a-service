// Application Azure Key Vault
resource "azurerm_key_vault" "application" {
  name                          = "${var.name}-${random_string.main.result}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enabled_for_disk_encryption   = true
  enable_rbac_authorization     = true
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = true
  sku_name                      = "standard"
  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

// Private Endpoint for application key vaults
resource "azurerm_private_endpoint" "keyvault_application" {
  name                = "${var.name}-${random_string.main.result}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.cluster_subnet_id

  private_service_connection {
    name                           = "${var.name}-${random_string.main.result}-pe-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.application.id
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "${var.name}-${random_string.main.result}-pe-pdzg"
    private_dns_zone_ids = [var.keyvault_private_dns_zone_id]
  }
}

// RBAC - Terraform account administrator of Azure Key Vaults
resource "azurerm_role_assignment" "application_kv" {
  scope                = azurerm_key_vault.application.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}
