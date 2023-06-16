resource "azurerm_user_assigned_identity" "runner" {
  count               = var.enable_runner ? 1 : 0
  name                = "runner-identity"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

data "azurerm_subscription" "current" {}

resource "azurerm_role_assignment" "runner" {
  count                = var.enable_runner ? 1 : 0
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.runner[0].principal_id
}

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
  count                           = var.enable_runner ? 1 : 0
  name                            = "runner-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B2s"
  admin_username                  = "tomas"
  disable_password_authentication = false
  admin_password                  = "Azure12345678"
  custom_data                     = base64encode(local.github_runner_script)

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.runner[0].id,
    ]
  }

  network_interface_ids = [
    azurerm_network_interface.runner[0].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    # offer   = "UbuntuServer"
    # sku     = "18.04-LTS"
    version = "latest"
  }

  boot_diagnostics {}

  lifecycle {
    ignore_changes = [
      custom_data,
    ]
  }
}

locals {
  github_runner_script = <<SCRIPT
#!/bin/bash
echo Installing Docker
apt-get update
apt-get install -y docker.io

echo Installing kubernetes tools
snap install kubectl --classic
snap install helm --classic
snap install k9s --classic

echo Installing Azure CLI
apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list
apt-get update
apt-get install -y azure-cli

echo Creating directory
mkdir actions-runner && cd actions-runner

echo Downloading runner
curl -o actions-runner-linux-x64-2.304.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.304.0/actions-runner-linux-x64-2.304.0.tar.gz

echo Extracting runner
tar xzf ./actions-runner-linux-x64-2.304.0.tar.gz

echo Configuring runner
export RUNNER_ALLOW_RUNASROOT=1
./config.sh --url https://github.com/tkubica12/aks-as-a-service --unattended --replace --name tomrunner --token ${var.github_runner_token}

echo Installing runner
./svc.sh install

echo Starting runner
./svc.sh start
SCRIPT
}
