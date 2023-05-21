locals {
  # List of regex syntax strings for allowed image paths
  default_allowed_images_regex_list = [
    "mcr.microsoft.com/.+",
    "example.azurecr.io/myregister/.+"
  ]

  default_allowed_images_regex = format("(%s)", join(")|(", local.default_allowed_images_regex_list))

  # Get set of applications that contain allowed image override
  standard_allowed_image_override = [for k, v in var.standard_applications : k if can(v.policy_exclusions.allowed_images_override)]
  confidential_allowed_image_override   = [for k, v in var.confidential_applications : k if can(v.policy_exclusions.allowed_images_override)]

  # Get set of applications that do not override allowed images
  standard_allowed_image_default = [for k, v in var.standard_applications : k if !can(v.policy_exclusions.allowed_images_override)]
  confidential_allowed_image_default   = [for k, v in var.confidential_applications : k if !can(v.policy_exclusions.allowed_images_override)]

  # Concat default list from standard and confidential
  allowed_image_default  = concat(local.standard_allowed_image_default, local.confidential_allowed_image_default)
}

// allowed_image_default
// Kubernetes clusters should be accessible only over HTTPS
resource "azurerm_resource_policy_assignment" "allowed_image_default" {
  name                 = "allowed_image_default"
  resource_id          = azurerm_kubernetes_cluster.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/febd0533-8e55-448f-b837-bd0e06f16469"

  parameters = <<EOF
{
    "effect": {"value": "Deny"},
    "namespaces": {"value": ${jsonencode(local.allowed_image_default)}},
    "allowedContainerImagesRegex": {"value": ${jsonencode(local.default_allowed_images_regex)}}
}
EOF
}

// standard_allowed_image_override
// Kubernetes clusters should be accessible only over HTTPS
resource "azurerm_resource_policy_assignment" "standard_allowed_image_override" {
  for_each             = toset(local.standard_allowed_image_override)
  name                 = "allowed_image_override_${each.key}"
  resource_id          = azurerm_kubernetes_cluster.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/febd0533-8e55-448f-b837-bd0e06f16469"

  parameters = <<EOF
{
    "effect": {"value": "Deny"},
    "namespaces": {"value": ["${each.key}"]},
    "allowedContainerImagesRegex": {"value": ${jsonencode(format("(%s)", join(")|(", var.standard_applications[each.key].policy_exclusions.allowed_images_override)))}}
}
EOF
}

// confidential_allowed_image_override
// Kubernetes clusters should be accessible only over HTTPS
resource "azurerm_resource_policy_assignment" "confidential_allowed_image_override" {
  for_each             = toset(local.confidential_allowed_image_override)
  name                 = "allowed_image_override_${each.key}"
  resource_id          = azurerm_kubernetes_cluster.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/febd0533-8e55-448f-b837-bd0e06f16469"

  parameters = <<EOF
{
    "effect": {"value": "Deny"},
    "namespaces": {"value": ["${each.key}"]},
    "allowedContainerImagesRegex": {"value": ${jsonencode(format("(%s)", join(")|(", var.confidential_applications[each.key].policy_exclusions.allowed_images_override)))}}
}
EOF
}
