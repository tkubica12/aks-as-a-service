resource "random_password" "password" {
  length           = 16
  special          = true
  numeric          = true
  lower            = true
  upper            = true
  override_special = "!"
}

resource "azuread_user" "main" {
  count               = var.provision_aad ? 10 : 0
  user_principal_name = "aks-u${count.index}@tkubica.biz"
  display_name        = "AKS User ${count.index}"
  password            = random_password.password.result
}
