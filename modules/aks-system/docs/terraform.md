<!-- BEGIN_TF_DOCS -->


# Terraform documentation
<!-- markdownlint-disable MD033 -->

## Requirements

The following requirements are needed by this module:

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~>1)

## Modules

No modules.

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_api_subnet_id"></a> [api\_subnet\_id](#input\_api\_subnet\_id)

Description: n/a

Type: `string`

### <a name="input_cluster_private_dns_zone_id"></a> [cluster\_private\_dns\_zone\_id](#input\_cluster\_private\_dns\_zone\_id)

Description: n/a

Type: `string`

### <a name="input_cluster_subnet_id"></a> [cluster\_subnet\_id](#input\_cluster\_subnet\_id)

Description: n/a

Type: `string`

### <a name="input_confidential_applications"></a> [confidential\_applications](#input\_confidential\_applications)

Description: n/a

Type: `any`

### <a name="input_ingress_types"></a> [ingress\_types](#input\_ingress\_types)

Description: n/a

Type: `any`

### <a name="input_keyvault_private_dns_zone_id"></a> [keyvault\_private\_dns\_zone\_id](#input\_keyvault\_private\_dns\_zone\_id)

Description: n/a

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: n/a

Type: `string`

### <a name="input_log_analytics_id_defender"></a> [log\_analytics\_id\_defender](#input\_log\_analytics\_id\_defender)

Description: n/a

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: n/a

Type: `string`

### <a name="input_node_sku"></a> [node\_sku](#input\_node\_sku)

Description: n/a

Type: `string`

### <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id)

Description: n/a

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: n/a

Type: `string`

### <a name="input_shared_nodepools"></a> [shared\_nodepools](#input\_shared\_nodepools)

Description: n/a

Type: `any`

### <a name="input_standard_applications"></a> [standard\_applications](#input\_standard\_applications)

Description: n/a

Type: `any`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_cluster_admin_principal_id"></a> [cluster\_admin\_principal\_id](#input\_cluster\_admin\_principal\_id)

Description: n/a

Type: `string`

Default: `"b0797e57-4a37-4f7d-9def-b312831bc3d7"`

### <a name="input_cluster_sku"></a> [cluster\_sku](#input\_cluster\_sku)

Description: n/a

Type: `string`

Default: `"Free"`

### <a name="input_cluster_upgrade_channel"></a> [cluster\_upgrade\_channel](#input\_cluster\_upgrade\_channel)

Description: n/a

Type: `string`

Default: `"stable"`

### <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version)

Description: n/a

Type: `string`

Default: `"1.24"`

### <a name="input_max_count"></a> [max\_count](#input\_max\_count)

Description: n/a

Type: `number`

Default: `3`

### <a name="input_min_count"></a> [min\_count](#input\_min\_count)

Description: n/a

Type: `number`

Default: `3`

### <a name="input_node_count"></a> [node\_count](#input\_node\_count)

Description: n/a

Type: `number`

Default: `3`

## Resources

The following resources are used by this module:

- [azurerm_api_management_gateway.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_gateway) (resource)
- [azurerm_disk_encryption_set.system](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) (resource)
- [azurerm_federated_identity_credential.shared_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) (resource)
- [azurerm_key_vault.system](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_key_vault_key.kms](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) (resource)
- [azurerm_key_vault_key.system_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) (resource)
- [azurerm_key_vault_secret.api_management_gateway_token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_kubernetes_cluster.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) (resource)
- [azurerm_kubernetes_cluster_node_pool.dedicated](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) (resource)
- [azurerm_kubernetes_cluster_node_pool.shared](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) (resource)
- [azurerm_log_analytics_workspace.monitor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) (resource)
- [azurerm_monitor_diagnostic_setting.forensic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_monitor_diagnostic_setting.operational](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_monitor_diagnostic_setting.security](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_private_endpoint.keyvault_system](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_resource_policy_assignment.allowed_image_default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) (resource)
- [azurerm_resource_policy_assignment.confidential_allowed_image_override](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) (resource)
- [azurerm_resource_policy_assignment.https_ingress_only](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) (resource)
- [azurerm_resource_policy_assignment.limit_volumes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) (resource)
- [azurerm_resource_policy_assignment.no_api_credentials](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) (resource)
- [azurerm_resource_policy_assignment.no_default_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) (resource)
- [azurerm_resource_policy_assignment.no_external_lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) (resource)
- [azurerm_resource_policy_assignment.no_priv_containers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) (resource)
- [azurerm_resource_policy_assignment.no_priv_escalation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) (resource)
- [azurerm_resource_policy_assignment.no_sysadmin_cap](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) (resource)
- [azurerm_resource_policy_assignment.no_sysctl](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) (resource)
- [azurerm_resource_policy_assignment.standard_allowed_image_override](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) (resource)
- [azurerm_role_assignment.aks_cluster_crypto_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.aks_managed_identity_operator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.aks_resource_group_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.cluster_admin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.kubeconfig](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.shared_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.system_disk_encryption_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.system_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_storage_account.monitor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [azurerm_user_assigned_identity.aks_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [azurerm_user_assigned_identity.aks_kubelet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [azurerm_user_assigned_identity.shared_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [random_string.aks_kv](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [random_string.monitor](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [azapi_resource_action.api_management_gateway_token](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource_action) (data source)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

## Outputs

The following outputs are exported:

### <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id)

Description: n/a

### <a name="output_cluster_identity_principal_id"></a> [cluster\_identity\_principal\_id](#output\_cluster\_identity\_principal\_id)

Description: n/a

### <a name="output_oidc_issuer_url"></a> [oidc\_issuer\_url](#output\_oidc\_issuer\_url)

Description: n/a

### <a name="output_shared_identity_client_id"></a> [shared\_identity\_client\_id](#output\_shared\_identity\_client\_id)

Description: n/a

### <a name="output_shared_keyvault_name"></a> [shared\_keyvault\_name](#output\_shared\_keyvault\_name)

Description: n/a

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->