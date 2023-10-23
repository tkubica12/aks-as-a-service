resource "azurerm_kubernetes_cluster" "main" {
  name                      = var.name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  dns_prefix                = var.name
  workload_identity_enabled = true                                  # Enable workload identity federation
  oidc_issuer_enabled       = true                                  # Enable cluster identity for workload federation
  disk_encryption_set_id    = azurerm_disk_encryption_set.system.id # Enable encryption of platform disks
  azure_policy_enabled      = true                                  # Enable Azure Policy
  local_account_disabled    = false                                 # Local account access
  # image_cleaner_enabled        = true                               # Clean up images regularly
  # image_cleaner_interval_hours = 24                                 # Interval for cleaning images
  sku_tier                  = var.cluster_sku
  private_dns_zone_id       = var.cluster_private_dns_zone_id
  private_cluster_enabled   = true
  automatic_channel_upgrade = var.cluster_upgrade_channel
  kubernetes_version        = var.cluster_version

  maintenance_window {
    allowed {
      day   = "Wednesday"
      hours = [2, 3]
    }
    allowed {
      day   = "Saturday"
      hours = [1, 2, 3, 4]
    }
    allowed {
      day   = "Sunday"
      hours = [1, 2, 3, 4]
    }
  }

  api_server_access_profile {
    subnet_id                = var.api_subnet_id
    vnet_integration_enabled = true
  }

  kubelet_identity {
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_kubelet.id
    client_id                 = azurerm_user_assigned_identity.aks_kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.aks_kubelet.principal_id
  }

  network_profile {
    network_policy      = "calico"
    network_plugin      = "azure"
    network_plugin_mode = "Overlay"
    service_cidr        = "192.168.196.0/22"
    dns_service_ip      = "192.168.196.10"
  }

  default_node_pool {
    name                   = "system"
    node_count             = var.node_count
    vm_size                = var.node_sku
    enable_host_encryption = true # Enable host encryption of temp disk and storage access
    os_disk_type           = "Managed"
    os_disk_size_gb        = 128
    os_sku                 = "CBLMariner"
    vnet_subnet_id         = var.cluster_subnet_id
    zones                  = [1, 2, 3]

    node_labels = {
      "dedication" = "system"
    }
  }

  key_management_service { # Etcd encryption at rest (eg. for Kubernetes Secrets)
    key_vault_key_id         = azurerm_key_vault_key.kms.id
    key_vault_network_access = "Private"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_cluster.id]
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true # Enable SecretProviderClass
  }

  azure_active_directory_role_based_access_control {
    managed            = true # Enable AAD authnetication
    azure_rbac_enabled = true # Enable Azure AAD Authorization
  }

  microsoft_defender {
    log_analytics_workspace_id = var.log_analytics_id_defender
  }

  depends_on = [
    azurerm_role_assignment.aks_managed_identity_operator,
    azurerm_role_assignment.aks_cluster_crypto_user,
    azurerm_role_assignment.subnets,
    azurerm_role_assignment.vnet,
    azurerm_role_assignment.private_dns_zone,
    azurerm_private_endpoint.keyvault_system
  ]

  lifecycle {  
    ignore_changes = [ network_profile[0].network_plugin_mode ]  # short term workaround for fix in 3.62.0
  }
}

