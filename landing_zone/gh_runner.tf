resource "azurerm_network_interface" "runner" {
  count               = var.enable_runner ? 1 : 0
  name                = "runner-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jump.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "runner" {
  count               = var.enable_runner ? 1 : 0
  name                            = "runner-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B2s"
  admin_username                  = "tomas"
  disable_password_authentication = false
  admin_password                  = "Azure12345678:"
  # custom_data         = filebase64("jump_install.sh")

  network_interface_ids = [
    azurerm_network_interface.runner[0].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    # offer     = "0001-com-ubuntu-server-jammy"
    # sku       = "22_04-lts"
    offer   = "UbuntuServer"
    sku     = "18.04-LTS"
    version = "latest"
  }

  boot_diagnostics {}
}
