// In existing API Management service create one or more self-hosted gateways as defined in ingress_type.apim
resource "azurerm_api_management_gateway" "main" {
  for_each          = var.ingress_types.apim
  name              = "${var.name}-${each.key}"
  api_management_id = each.value.api_management_id
  description       = "Example API Management gateway"

  location_data {
    name     = "example name"
    city     = "example city"
    district = "example district"
    region   = "example region"
  }
}

// Generate token for innitial pairing of self-hosted gateway with API Management service
data "azapi_resource_action" "api_management_gateway_token" {
  for_each    = var.ingress_types.apim
  type        = "Microsoft.ApiManagement/service/gateways@2022-04-01-preview"
  resource_id = azurerm_api_management_gateway.main[each.key].id
  action      = "generateToken"

  body = <<EOF
{
  "keyType": "primary",
  "expiry": "${timeadd(timestamp(), "336h")}"
}
EOF

  response_export_values = ["*"]
}

// Store token in Key Vault
resource "azurerm_key_vault_secret" "api_management_gateway_token" {
  for_each     = var.ingress_types.apim
  name         = "${each.key}"
  value        = "GatewayKey ${jsondecode(data.azapi_resource_action.api_management_gateway_token[each.key].output).value}"
  key_vault_id = azurerm_key_vault.system.id
}
