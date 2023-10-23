// Create identity for cluster
resource "azurerm_user_assigned_identity" "aks_cluster" {
  name                = "${var.name}-cluster"
  location            = var.location
  resource_group_name = var.resource_group_name
}

// Create identity for kubelet
resource "azurerm_user_assigned_identity" "aks_kubelet" {
  name                = "${var.name}-kubelet"
  location            = var.location
  resource_group_name = var.resource_group_name
}

// RBAC - Grant the AKS cluster identity manage identities for kubelet
resource "azurerm_role_assignment" "aks_managed_identity_operator" {
  scope                = azurerm_user_assigned_identity.aks_kubelet.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.aks_cluster.principal_id
}

// RBAC - Grant the AKS cluster identity access to the resource group
resource "azurerm_role_assignment" "aks_resource_group_contributor" {
  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_cluster.principal_id
}

// RBAC - Cluster administrator
resource "azurerm_role_assignment" "cluster_admin" {
  scope                = azurerm_kubernetes_cluster.main.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = var.cluster_admin_principal_id
}


// RBAC - Users to be able to read kubeconfig
locals {
  v123_readers      = flatten([for app, value in var.standard_applications : [for k, v in value.permanent_readers : v.object_id]])
  v123_writers      = flatten([for app, value in var.standard_applications : [for k, v in value.permanent_writers : v.object_id]])
  v4_readers        = flatten([for app, value in var.confidential_applications : [for k, v in value.permanent_readers : v.object_id]])
  v4_writers        = flatten([for app, value in var.confidential_applications : [for k, v in value.permanent_writers : v.object_id]])
  unique_object_ids = toset(distinct(flatten([local.v123_readers, local.v123_writers, local.v4_readers, local.v4_writers])))
}

resource "azurerm_role_assignment" "kubeconfig" {
  for_each             = local.unique_object_ids
  scope                = azurerm_kubernetes_cluster.main.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = each.value
}

// RBAC - Cluster administrator eligibility (PIM)
# resource "random_uuid" "pim_cluster_admin" {}

# resource "azapi_resource" "pim_cluster_admin" {
#   type      = "Microsoft.Authorization/roleEligibilityScheduleRequests@2022-04-01-preview"
#   name      = random_uuid.pim_cluster_admin.result
#   parent_id = azurerm_kubernetes_cluster.main.id
#   body = jsonencode({
#     properties = {
#       justification    = "Why you need to get cluster admin access?"
#       principalId      = var.cluster_admin_principal_id
#       requestType      = "AdminAssign"
#       roleDefinitionId = "/providers/Microsoft.Authorization/roleDefinitions/b1ff04bb-8a4e-4dconfidential-8eb5-8693973ce19b" # Azure Kubernetes Service RBAC Cluster Admin
#       scheduleInfo = {
#         expiration = {
#           duration = "PT2H"
#           type     = "AfterDuration"
#         }
#         startDateTime = "2023-00-00T00:00:00.00000+01:00"
#       }
#     }
#   })
# }

// RBAC - cluster identity to access private DNS zone
resource "azurerm_role_assignment" "private_dns_zone" {
  scope                = var.cluster_private_dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_cluster.principal_id
}

// RBAC - cluster identity to access subnets
locals {
  system_subnet_ids       = [var.cluster_subnet_id, var.api_subnet_id]
  ingress_type_subnet_ids = flatten([for type, objects in var.ingress_types : [for k, v in objects : v.subnet_id]])
  confidential_subnet_ids = flatten([for app, values in var.confidential_applications : values.subnet_id])
  all_subnets             = toset(distinct(concat(local.system_subnet_ids, local.ingress_type_subnet_ids, local.confidential_subnet_ids)))
}

resource "azurerm_role_assignment" "subnets" {
  for_each             = local.all_subnets
  scope                = each.key
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_cluster.principal_id
}

// RBAC - cluster identity to have join/action on VNET
resource "azurerm_role_assignment" "vnet" {
  scope                = element(split("/subnet", var.cluster_subnet_id), 0)
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_cluster.principal_id
} 
