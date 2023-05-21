// Generate name for monitoring resources
resource "random_string" "monitor" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  numeric = false
}

// Storage account for monitoring
resource "azurerm_storage_account" "monitor" {
  name                     = random_string.monitor.result
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

// Log analytics workspace for monitoring
resource "azurerm_log_analytics_workspace" "monitor" {
  name                = random_string.monitor.result
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

// Operational logging
resource "azurerm_monitor_diagnostic_setting" "operational" {
  name               = "operational"
  target_resource_id = azurerm_kubernetes_cluster.main.id
  #storage_account_id             = azurerm_storage_account.monitor.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.monitor.id
  #log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "kube-controller-manager"

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  # enabled_log {
  #   category = "cloud-controller-manager"

  #   retention_policy {
  #     days    = 0
  #     enabled = false
  #   }
  # }

  enabled_log {
    category = "cluster-autoscaler"

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  enabled_log {
    category = "csi-azuredisk-controller"

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  enabled_log {
    category = "csi-azurefile-controller"

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}

// Security logging
resource "azurerm_monitor_diagnostic_setting" "security" {
  name               = "security"
  target_resource_id = azurerm_kubernetes_cluster.main.id
  #storage_account_id             = azurerm_storage_account.monitor.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.monitor.id
  #log_analytics_destination_type = "Dedicated"

  # enabled_log {
  #   category = "kube-audit-admin"

  #   retention_policy {
  #     days    = 0
  #     enabled = false
  #   }
  # }

  enabled_log {
    category = "guard"

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}

// Forensic logging
resource "azurerm_monitor_diagnostic_setting" "forensic" {
  name               = "forensic"
  target_resource_id = azurerm_kubernetes_cluster.main.id
  storage_account_id = azurerm_storage_account.monitor.id
  #log_analytics_workspace_id     = azurerm_log_analytics_workspace.monitor.id
  #log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "kube-audit-admin"

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  enabled_log {
    category = "kube-audit"

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  enabled_log {
    category = "kube-apiserver"

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  enabled_log {
    category = "guard"

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
