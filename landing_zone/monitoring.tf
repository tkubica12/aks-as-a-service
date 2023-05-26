resource "random_string" "logs" {
  upper   = false
  lower   = true
  numeric = false
  special = false
  length  = 16
}

resource "azurerm_log_analytics_workspace" "logs" {
  name                = random_string.logs.result
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
}
