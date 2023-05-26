resource "azurerm_network_interface" "jump" {
  count               = var.enable_jump ? 1 : 0
  name                = "jump-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jump.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jump[0].id
  }
}

resource "azurerm_public_ip" "jump" {
  count               = var.enable_jump ? 1 : 0
  name                = "jump-ip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "jump" {
  count               = var.enable_jump ? 1 : 0
  name                = "jump-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${var.my_ip}/32"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "jump" {
  count                     = var.enable_jump ? 1 : 0
  network_interface_id      = azurerm_network_interface.jump[0].id
  network_security_group_id = azurerm_network_security_group.jump.id
}

resource "azurerm_linux_virtual_machine" "jump" {
  count                           = var.enable_jump ? 1 : 0
  name                            = "jump-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B2s"
  admin_username                  = "tomas"
  disable_password_authentication = false
  admin_password                  = "Azure12345678"
  custom_data                     = filebase64("jump_install.sh")

  network_interface_ids = [
    azurerm_network_interface.jump[0].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  boot_diagnostics {}

  lifecycle {
    ignore_changes = [custom_data]
  }
}
