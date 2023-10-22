resource "azurerm_virtual_network" "cluster01" {
  name                = "cluster01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_servers         = [azurerm_private_dns_resolver_inbound_endpoint.main.ip_configurations[0].private_ip_address]
}

resource "azurerm_subnet" "aks_api" {
  name                 = "aks-api"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.cluster01.name
  address_prefixes     = ["10.0.0.0/28"]

  delegation {
    name = "aks-delegation"

    service_delegation {
      name    = "Microsoft.ContainerService/managedClusters"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "aks_inbound_internal" {
  name                 = "aks-inbound-internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.cluster01.name
  address_prefixes     = ["10.0.0.16/29"]
}

resource "azurerm_subnet" "aks_inbound_external" {
  name                 = "aks-inbound-external"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.cluster01.name
  address_prefixes     = ["10.0.0.24/29"]
}

resource "azurerm_subnet" "aks_system" {
  name                                      = "aks-system"
  resource_group_name                       = azurerm_resource_group.main.name
  virtual_network_name                      = azurerm_virtual_network.cluster01.name
  address_prefixes                          = ["10.0.0.32/27"]
  private_endpoint_network_policies_enabled = true
}

resource "azurerm_subnet" "aks_shared" {
  name                                      = "aks-shared"
  resource_group_name                       = azurerm_resource_group.main.name
  virtual_network_name                      = azurerm_virtual_network.cluster01.name
  address_prefixes                          = ["10.0.0.64/27"]
  private_endpoint_network_policies_enabled = true
}

resource "azurerm_subnet" "s201" {
  name                                      = "s201"
  resource_group_name                       = azurerm_resource_group.main.name
  virtual_network_name                      = azurerm_virtual_network.cluster01.name
  address_prefixes                          = ["10.0.0.96/27"]
  private_endpoint_network_policies_enabled = true
}

resource "azurerm_subnet" "s202" {
  name                                      = "s202"
  resource_group_name                       = azurerm_resource_group.main.name
  virtual_network_name                      = azurerm_virtual_network.cluster01.name
  address_prefixes                          = ["10.0.0.128/27"]
  private_endpoint_network_policies_enabled = true
}

resource "azurerm_subnet" "jump" {
  name                                      = "jump"
  resource_group_name                       = azurerm_resource_group.main.name
  virtual_network_name                      = azurerm_virtual_network.cluster01.name
  address_prefixes                          = ["10.0.99.0/24"]
  private_endpoint_network_policies_enabled = false
}
