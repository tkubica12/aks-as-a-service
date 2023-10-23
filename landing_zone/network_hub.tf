resource "azurerm_virtual_network" "hub" {
  name                = "hub"
  address_space       = ["10.80.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "gw" {
  name                                      = "GatewaySubnet"
  resource_group_name                       = azurerm_resource_group.main.name
  virtual_network_name                      = azurerm_virtual_network.hub.name
  address_prefixes                          = ["10.80.0.0/24"]
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_subnet" "fw" {
  name                                      = "AzureFirewallSubnet"
  resource_group_name                       = azurerm_resource_group.main.name
  virtual_network_name                      = azurerm_virtual_network.hub.name
  address_prefixes                          = ["10.80.1.0/24"]
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_subnet" "fw_management" {
  name                                      = "AzureFirewallManagementSubnet"
  resource_group_name                       = azurerm_resource_group.main.name
  virtual_network_name                      = azurerm_virtual_network.hub.name
  address_prefixes                          = ["10.80.2.0/24"]
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_subnet" "dns_in" {
  name                 = "inbounddns"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.80.3.0/24"]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource "azurerm_subnet" "ampls" {
  name                                      = "ampls"
  resource_group_name                       = azurerm_resource_group.main.name
  virtual_network_name                      = azurerm_virtual_network.hub.name
  address_prefixes                          = ["10.80.4.0/24"]
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_subnet" "bastion" {
  name                                      = "AzureBastionSubnet"
  resource_group_name                       = azurerm_resource_group.main.name
  virtual_network_name                      = azurerm_virtual_network.hub.name
  address_prefixes                          = ["10.80.5.0/24"]
  private_endpoint_network_policies_enabled = false
}
