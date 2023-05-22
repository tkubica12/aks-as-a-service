# locals {
#     cluster = tomap({"cluster_name" = local.manifest.name})
#     cluster_map = tomap({"cluster" = local.cluster})
#     aks_system_map = tomap({"aks_system" = module.aks_system})
#     aks_dedicated_nodepools = tomap({"aks_dedicated_nodepools" = module.aks_dedicated_nodepools})
#     aks_shared_nodepools = tomap({"aks_shared_nodepools" = module.aks_shared_nodepools})
#     merged_outputs = merge(local.cluster_map, local.aks_system_map, local.aks_dedicated_nodepools, local.aks_shared_nodepools)
# }


locals {
    application_identities = tomap({"application_identities" =  { for sas, values in module.aks_apps: sas => values.application_identities }} )
    shared_identity_client_id = {"shared_identity_client_id"  = module.aks_system.shared_identity_client_id}
    shared_keyvault_name = {"shared_keyvault_name"  = module.aks_system.shared_keyvault_name}
    merged_output = merge(local.application_identities, local.shared_identity_client_id, local.shared_keyvault_name)
}

output "runtime" {
  value = yamlencode(local.merged_output)
  description = <<DESCRIPTION

Compiles runtime information such as identitz IDs and other properties and outputs it as YAML.

This will be used in cluster/clustername root that calls this to store runtime.yaml in Git that is then read by ArgoCD to get access to this kind of information.
DESCRIPTION
}