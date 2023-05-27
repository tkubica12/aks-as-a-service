output "password" {
  value = random_password.password.result
  sensitive = true
}

output "runner_client_id" {
  value = azurerm_user_assigned_identity.runner[0].client_id
}