resource "random_string" "logs" {
  upper   = false
  lower   = true
  numeric = false
  special = false
  length  = 16
}

// Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "logs" {
  name                = random_string.logs.result
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
}

// Map Log Analytics Workspace to AMPLS
resource "azurerm_monitor_private_link_scoped_service" "logs" {
  name                = "hub-logs"
  resource_group_name = azurerm_resource_group.main.name
  scope_name          = azurerm_monitor_private_link_scope.main.name
  linked_resource_id  = azurerm_log_analytics_workspace.logs.id
}
