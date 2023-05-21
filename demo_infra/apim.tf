resource "random_string" "apim" {
  length  = 12
  upper   = false
  lower   = true
  numeric = false
  special = false
}

resource "azurerm_api_management" "main" {
  name                = random_string.apim.result
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  publisher_name      = "admin"
  publisher_email     = "admin@tkubica.biz"
  sku_name            = "Developer_1"
}
