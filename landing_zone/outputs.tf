output "jump_ip" {
  value = azurerm_public_ip.jump.ip_address
}

output "password" {
  value = random_password.password.result
  sensitive = true
}