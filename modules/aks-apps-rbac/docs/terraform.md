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

### <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id)

Description: n/a

Type: `string`

### <a name="input_cluster_subnet_id"></a> [cluster\_subnet\_id](#input\_cluster\_subnet\_id)

Description: n/a

Type: `string`

### <a name="input_keyvault_private_dns_zone_id"></a> [keyvault\_private\_dns\_zone\_id](#input\_keyvault\_private\_dns\_zone\_id)

Description: n/a

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: n/a

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: n/a

Type: `string`

### <a name="input_namespace"></a> [namespace](#input\_namespace)

Description: n/a

Type: `string`

### <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url)

Description: n/a

Type: `string`

### <a name="input_permanent_readers"></a> [permanent\_readers](#input\_permanent\_readers)

Description: n/a

Type: `any`

### <a name="input_permanent_writers"></a> [permanent\_writers](#input\_permanent\_writers)

Description: n/a

Type: `any`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: n/a

Type: `string`

## Optional Inputs

No optional inputs.

## Resources

The following resources are used by this module:

- [azurerm_disk_encryption_set.application](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) (resource)
- [azurerm_federated_identity_credential.application_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) (resource)
- [azurerm_key_vault.application](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_key_vault_key.application_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) (resource)
- [azurerm_private_endpoint.keyvault_application](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_role_assignment.application_disk_encryption_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.application_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.application_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.readers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.writers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_user_assigned_identity.application_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [random_string.main](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

## Outputs

The following outputs are exported:

### <a name="output_application_identities"></a> [application\_identities](#output\_application\_identities)

Description: n/a

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->