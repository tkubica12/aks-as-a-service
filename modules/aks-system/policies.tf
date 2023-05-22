locals {
  # For specific policy loop applications, return set of images if any, than flatten results
  standard_no_priv_containers_image_exclusions     = flatten([for k, v in var.standard_applications : v.policy_exclusions.no_priv_containers.image_exclusions if can(v.policy_exclusions.no_priv_containers.image_exclusions)])
  confidential_no_priv_containers_image_exclusions = flatten([for k, v in var.confidential_applications : v.policy_exclusions.no_priv_containers.image_exclusions if can(v.policy_exclusions.no_priv_containers.image_exclusions)])

  standard_limit_volumes_image_exclusions     = flatten([for k, v in var.standard_applications : v.policy_exclusions.limit_volumes.image_exclusions if can(v.policy_exclusions.limit_volumes.image_exclusions)])
  confidential_limit_volumes_image_exclusions = flatten([for k, v in var.confidential_applications : v.policy_exclusions.limit_volumes.image_exclusions if can(v.policy_exclusions.limit_volumes.image_exclusions)])

  standard_no_priv_escalation_image_exclusions     = flatten([for k, v in var.standard_applications : v.policy_exclusions.no_priv_escalation.image_exclusions if can(v.policy_exclusions.no_priv_escalation.image_exclusions)])
  confidential_no_priv_escalation_image_exclusions = flatten([for k, v in var.confidential_applications : v.policy_exclusions.no_priv_escalation.image_exclusions if can(v.policy_exclusions.no_priv_escalation.image_exclusions)])

  standard_no_sysadmin_cap_image_exclusions     = flatten([for k, v in var.standard_applications : v.policy_exclusions.no_sysadmin_cap.image_exclusions if can(v.policy_exclusions.no_sysadmin_cap.image_exclusions)])
  confidential_no_sysadmin_cap_image_exclusions = flatten([for k, v in var.confidential_applications : v.policy_exclusions.no_sysadmin_cap.image_exclusions if can(v.policy_exclusions.no_sysadmin_cap.image_exclusions)])

  standard_no_api_credentials_image_exclusions     = flatten([for k, v in var.standard_applications : v.policy_exclusions.no_api_credentials.image_exclusions if can(v.policy_exclusions.no_api_credentials.image_exclusions)])
  confidential_no_api_credentials_image_exclusions = flatten([for k, v in var.confidential_applications : v.policy_exclusions.no_api_credentials.image_exclusions if can(v.policy_exclusions.no_api_credentials.image_exclusions)])

  # For specific policy loop applications, return application name if field exclude_whole_namespace exists and containst value true
  standard_no_priv_containers_namespace_exclusions     = [for k, v in var.standard_applications : k if try(v.policy_exclusions.no_priv_containers.exclude_whole_namespace == true, false)]
  confidential_no_priv_containers_namespace_exclusions = [for k, v in var.confidential_applications : k if try(v.policy_exclusions.no_priv_containers.exclude_whole_namespace == true, false)]

  standard_https_ingress_only_namespace_exclusions     = [for k, v in var.standard_applications : k if try(v.policy_exclusions.https_ingress_only.exclude_whole_namespace == true, false)]
  confidential_https_ingress_only_namespace_exclusions = [for k, v in var.confidential_applications : k if try(v.policy_exclusions.https_ingress_only.exclude_whole_namespace == true, false)]

  standard_limit_volumes_namespace_exclusions     = [for k, v in var.standard_applications : k if try(v.policy_exclusions.limit_volumes.exclude_whole_namespace == true, false)]
  confidential_limit_volumes_namespace_exclusions = [for k, v in var.confidential_applications : k if try(v.policy_exclusions.limit_volumes.exclude_whole_namespace == true, false)]

  standard_no_priv_escalation_namespace_exclusions     = [for k, v in var.standard_applications : k if try(v.policy_exclusions.no_priv_escalation.exclude_whole_namespace == true, false)]
  confidential_no_priv_escalation_namespace_exclusions = [for k, v in var.confidential_applications : k if try(v.policy_exclusions.no_priv_escalation.exclude_whole_namespace == true, false)]

  standard_no_sysctl_namespace_exclusions     = [for k, v in var.standard_applications : k if try(v.policy_exclusions.no_sysctl.exclude_whole_namespace == true, false)]
  confidential_no_sysctl_namespace_exclusions = [for k, v in var.confidential_applications : k if try(v.policy_exclusions.no_sysctl.exclude_whole_namespace == true, false)]

  standard_no_sysadmin_cap_namespace_exclusions     = [for k, v in var.standard_applications : k if try(v.policy_exclusions.no_sysadmin_cap.exclude_whole_namespace == true, false)]
  confidential_no_sysadmin_cap_namespace_exclusions = [for k, v in var.confidential_applications : k if try(v.policy_exclusions.no_sysadmin_cap.exclude_whole_namespace == true, false)]

  standard_no_external_lb_namespace_exclusions     = [for k, v in var.standard_applications : k if try(v.policy_exclusions.no_external_lb.exclude_whole_namespace == true, false)]
  confidential_no_external_lb_namespace_exclusions = [for k, v in var.confidential_applications : k if try(v.policy_exclusions.no_external_lb.exclude_whole_namespace == true, false)]

  standard_no_api_credentials_namespace_exclusions     = [for k, v in var.standard_applications : k if try(v.policy_exclusions.no_api_credentials.exclude_whole_namespace == true, false)]
  confidential_no_api_credentials_namespace_exclusions = [for k, v in var.confidential_applications : k if try(v.policy_exclusions.no_api_credentials.exclude_whole_namespace == true, false)]

  # Default namespace exclusions
  default_no_priv_containers_namespace_exclusions = ["kube-system", "gatekeeper-system", "shared-components"]
  default_https_ingress_only_namespace_exclusions = ["kube-system", "gatekeeper-system"]
  default_limit_volumes_namespace_exclusions      = ["kube-system", "gatekeeper-system", "shared-components"]
  default_no_priv_escalation_namespace_exclusions = ["kube-system", "gatekeeper-system", "shared-components"]
  default_no_sysctl_namespace_exclusions          = ["kube-system", "gatekeeper-system"]
  default_no_sysadmin_cap_namespace_exclusions    = ["kube-system", "gatekeeper-system"]
  default_no_external_lb_namespace_exclusions     = ["kube-system", "gatekeeper-system", "shared-components"]
  default_no_api_credentials_namespace_exclusions = ["kube-system", "gatekeeper-system", "shared-components"]

  # Default image exclusions
  default_no_priv_containers_image_exclusions = ["mcr.microsoft.com/mcr/hello-world:*"]
  default_limit_volumes_image_exclusions      = []
  default_no_priv_escalation_image_exclusions = []
  default_no_sysadmin_cap_image_exclusions    = []
  default_no_api_credentials_image_exclusions = []

  # Concat results from standard and confidential applications and default exclusions
  no_priv_containers_image_exclusions     = distinct(concat(local.standard_no_priv_containers_image_exclusions, local.confidential_no_priv_containers_image_exclusions, local.default_no_priv_containers_image_exclusions))
  no_priv_containers_namespace_exclusions = concat(local.standard_no_priv_containers_namespace_exclusions, local.confidential_no_priv_containers_namespace_exclusions, local.default_no_priv_containers_namespace_exclusions)

  https_ingress_only_namespace_exclusions = concat(local.standard_https_ingress_only_namespace_exclusions, local.confidential_https_ingress_only_namespace_exclusions, local.default_https_ingress_only_namespace_exclusions)

  limit_volumes_image_exclusions     = distinct(concat(local.standard_limit_volumes_image_exclusions, local.confidential_limit_volumes_image_exclusions, local.default_limit_volumes_image_exclusions))
  limit_volumes_namespace_exclusions = concat(local.standard_limit_volumes_namespace_exclusions, local.confidential_limit_volumes_namespace_exclusions, local.default_limit_volumes_namespace_exclusions)

  no_priv_escalation_image_exclusions     = distinct(concat(local.standard_no_priv_escalation_image_exclusions, local.confidential_no_priv_escalation_image_exclusions, local.default_no_priv_escalation_image_exclusions))
  no_priv_escalation_namespace_exclusions = concat(local.standard_no_priv_escalation_namespace_exclusions, local.confidential_no_priv_escalation_namespace_exclusions, local.default_no_priv_escalation_namespace_exclusions)

  no_sysctl_namespace_exclusions = concat(local.standard_no_sysctl_namespace_exclusions, local.confidential_no_sysctl_namespace_exclusions, local.default_no_sysctl_namespace_exclusions)

  no_sysadmin_cap_image_exclusions     = distinct(concat(local.standard_no_sysadmin_cap_image_exclusions, local.confidential_no_sysadmin_cap_image_exclusions, local.default_no_sysadmin_cap_image_exclusions))
  no_sysadmin_cap_namespace_exclusions = concat(local.standard_no_sysadmin_cap_namespace_exclusions, local.confidential_no_sysadmin_cap_namespace_exclusions, local.default_no_sysadmin_cap_namespace_exclusions)

  no_external_lb_namespace_exclusions = concat(local.standard_no_external_lb_namespace_exclusions, local.confidential_no_external_lb_namespace_exclusions, local.default_no_external_lb_namespace_exclusions)

  no_api_credentials_image_exclusions     = distinct(concat(local.standard_no_api_credentials_image_exclusions, local.confidential_no_api_credentials_image_exclusions, local.default_no_api_credentials_image_exclusions))
  no_api_credentials_namespace_exclusions = concat(local.standard_no_api_credentials_namespace_exclusions, local.confidential_no_api_credentials_namespace_exclusions, local.default_no_api_credentials_namespace_exclusions)
}

// no_priv_containers
// Kubernetes cluster should not allow privileged containers
resource "azurerm_resource_policy_assignment" "no_priv_containers" {
  name                 = "no_priv_containers"
  resource_id          = azurerm_kubernetes_cluster.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4"

  parameters = <<EOF
{
    "effect": {"value": "Deny"},
    "excludedNamespaces": {"value": ${jsonencode(local.no_priv_containers_namespace_exclusions)}},
    "excludedImages": {"value": ${jsonencode(local.no_priv_containers_image_exclusions)}}
}
EOF
}

// https_ingress_only
// Kubernetes clusters should be accessible only over HTTPS
resource "azurerm_resource_policy_assignment" "https_ingress_only" {
  name                 = "https_ingress_only"
  resource_id          = azurerm_kubernetes_cluster.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d"

  parameters = <<EOF
{
    "effect": {"value": "Deny"},
    "excludedNamespaces": {"value": ${jsonencode(local.https_ingress_only_namespace_exclusions)}}
}
EOF
}

// limit_volumes
// Kubernetes cluster pods should only use allowed volume types
// Use modern drivers only (CSI), do not allow hostPath (security risk) and emptyDir (use PVC to maintain isolation)
resource "azurerm_resource_policy_assignment" "limit_volumes" {
  name                 = "limit_volumes"
  resource_id          = azurerm_kubernetes_cluster.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/16697877-1118-4fb1-9b65-9898ec2509ec"

  parameters = <<EOF
{
    "effect": {"value": "Deny"},
    "allowedVolumeTypes": {"value": ["projected", "csi", "secret", "configMap", "persistentVolumeClaim"]},
    "excludedNamespaces": {"value": ${jsonencode(local.limit_volumes_namespace_exclusions)}},
    "excludedImages": {"value": ${jsonencode(local.limit_volumes_image_exclusions)}}
}
EOF
}

// no_priv_escalation
// Kubernetes clusters should not allow container privilege escalation
resource "azurerm_resource_policy_assignment" "no_priv_escalation" {
  name                 = "no_priv_escalation"
  resource_id          = azurerm_kubernetes_cluster.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99"

  parameters = <<EOF
{
    "effect": {"value": "Deny"},
    "excludedNamespaces": {"value": ${jsonencode(local.no_priv_escalation_namespace_exclusions)}},
    "excludedImages": {"value": ${jsonencode(local.no_priv_escalation_image_exclusions)}}
}
EOF
}

// no_sysctl
// Kubernetes cluster containers should not use forbidden sysctl interfaces
resource "azurerm_resource_policy_assignment" "no_sysctl" {
  name                 = "no_sysctl"
  resource_id          = azurerm_kubernetes_cluster.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/56d0a13f-712f-466b-8416-56fb354fb823"

  parameters = <<EOF
{
    "effect": {"value": "Deny"},
    "forbiddenSysctls": {"value": ["*"]},
    "excludedNamespaces": {"value": ${jsonencode(local.no_sysctl_namespace_exclusions)}}
}
EOF
}


// no_sysadmin_cap
// Kubernetes clusters should not grant CAP_SYS_ADMIN security capabilities
resource "azurerm_resource_policy_assignment" "no_sysadmin_cap" {
  name                 = "no_sysadmin_cap"
  resource_id          = azurerm_kubernetes_cluster.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/d2e7ea85-6b44-4317-a0be-1b951587f626"

  parameters = <<EOF
{
    "effect": {"value": "Deny"},
    "excludedNamespaces": {"value": ${jsonencode(local.no_sysadmin_cap_namespace_exclusions)}},
    "excludedImages": {"value": ${jsonencode(local.no_sysadmin_cap_image_exclusions)}}
}
EOF
}

// no_external_lb
// Kubernetes clusters should use internal load balancers
resource "azurerm_resource_policy_assignment" "no_external_lb" {
  name                 = "no_external_lb"
  resource_id          = azurerm_kubernetes_cluster.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/3fc4dc25-5baf-40d8-9b05-7fe74c1bc64e"

  parameters = <<EOF
{
    "effect": {"value": "Deny"},
    "excludedNamespaces": {"value": ${jsonencode(local.no_external_lb_namespace_exclusions)}}
}
EOF
}

// no_api_credentials
// Kubernetes clusters should disable automounting API credentials
resource "azurerm_resource_policy_assignment" "no_api_credentials" {
  name                 = "no_api_credentials"
  resource_id          = azurerm_kubernetes_cluster.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/423dd1ba-798e-40e4-9c4d-b6902674b423"

  parameters = <<EOF
{
    "effect": {"value": "Deny"},
    "excludedNamespaces": {"value": ${jsonencode(local.no_api_credentials_namespace_exclusions)}},
    "excludedImages": {"value": ${jsonencode(local.no_api_credentials_image_exclusions)}}
}
EOF
}

// no_default_namespace
// Kubernetes clusters should not use the default namespace
resource "azurerm_resource_policy_assignment" "no_default_namespace" {
  name                 = "no_default_namespace"
  resource_id          = azurerm_kubernetes_cluster.main.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/9f061a12-e40d-4183-a00e-171812443373"

  parameters = <<EOF
{
    "effect": {"value": "Deny"}
}
EOF
}
