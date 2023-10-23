locals {
  manifest = var.manifest
}

module "aks_system" {
  source                       = "./modules/aks-system"
  name                         = local.manifest.cluster_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  resource_group_id            = var.resource_group_id
  node_sku                     = local.manifest.system_nodepool.node_sku
  node_count                   = local.manifest.system_nodepool.node_count
  min_count                    = local.manifest.system_nodepool.min_count
  max_count                    = local.manifest.system_nodepool.max_count
  cluster_sku                  = local.manifest.cluster_sku
  cluster_version              = local.manifest.cluster_version
  cluster_subnet_id            = local.manifest.system_nodepool.subnet_id
  cluster_upgrade_channel      = local.manifest.cluster_upgrade_channel
  api_subnet_id                = local.manifest.api_subnet_id
  standard_applications        = local.manifest.standard_applications
  confidential_applications    = local.manifest.confidential_applications
  cluster_private_dns_zone_id  = local.manifest.cluster_private_dns_zone_id
  keyvault_private_dns_zone_id = local.manifest.keyvault_private_dns_zone_id
  shared_nodepools             = local.manifest.shared_nodepools
  ingress_types                = local.manifest.ingress_types
  log_analytics_id_defender    = "/subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/aks-as-a-service-lz/providers/Microsoft.OperationalInsights/workspaces/ntculrfixfarlmth"
  prometheus_dce_id            = "/subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/aks-as-a-service-monitoring/providers/Microsoft.Insights/dataCollectionEndpoints/aks-prometheus"
  prometheus_dcr_id = ""
}

module "aks_apps" {
  source                       = "./modules/aks-apps-rbac"
  for_each                     = merge(local.manifest.standard_applications, local.manifest.confidential_applications)
  cluster_id                   = module.aks_system.cluster_id
  cluster_subnet_id            = local.manifest.system_nodepool.subnet_id
  oidc_issuer_url              = module.aks_system.oidc_issuer_url
  namespace                    = each.key
  name                         = each.key
  location                     = var.location
  resource_group_name          = var.resource_group_name
  permanent_readers            = each.value.permanent_readers
  permanent_writers            = each.value.permanent_writers
  keyvault_private_dns_zone_id = local.manifest.keyvault_private_dns_zone_id
}
