<!-- BEGIN_TF_DOCS -->


# Terraform documentation
<!-- markdownlint-disable MD033 -->

## Requirements

No requirements.

## Modules

The following Modules are called:

### <a name="module_aks_apps"></a> [aks\_apps](#module\_aks\_apps)

Source: ./modules/aks-apps-rbac

Version:

### <a name="module_aks_system"></a> [aks\_system](#module\_aks\_system)

Source: ./modules/aks-system

Version:

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where cluster will be deployed

Type: `string`

### <a name="input_manifest"></a> [manifest](#input\_manifest)

Description:

**Manifest definition**  
Provide cluster configuration. Here is example with documentation in YAML form.

Suggested approach is to have separate folders for each cluster from which you reference this module and store manifest in YAML file. Call this module and pass its values using yamldecode(file("manifest.yaml"))

```yaml
## -- Definition of enterprise container platform cluster
## This file is used as input to Terraform, Helm/Argo and other tools
## providing single place to define cluster configuration.

# Name of cluster
cluster_name: cluster01
# Cluster Kubernetes version, use short style (eg. 1.24) especially if auto-upgrade is enabled
# You can also disable auto-upgrade and use explicit long version (eg. 1.24.5)
cluster_version: 1.24
# Cluster SKU, use Free for development and Standard for production
cluster_sku: Free
# Cluster auto-upgrade channel: patch, stable, rapid, node-image or none
cluster_upgrade_channel: patch
# OS auto-upgrade channel: SecurityPatch, NodeImage, Unmanaged or None -- PLACEHOLDER, wait for azurerm to implement this preview feature
os_upgrade_channel: SecurityPatch
# Cluster region
location: northeurope
# Cluster resource group
resource_group_name: cluster01
# Cluster subscription id
subscription_id: d3b7888f-c26e-4961-a976-ff9d5b31dfd3
# Cluster tenant id
tenant_id: d6af5f85-2a50-4370-b4b5-9b9a55bcb0dc
# Resource ID of network subnet for API server (must be delegated)
api_subnet_id: /subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/demo-infra/providers/Microsoft.Network/virtualNetworks/cluster01/subnets/aks-api
# Resource ID of private cluster DNS Zone
cluster_private_dns_zone_id: /subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/demo-infra/providers/Microsoft.Network/privateDnsZones/privatelink.northeurope.azmk8s.io
# Resource ID of private endpoint KeyVault DNS zone
keyvault_private_dns_zone_id: /subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/demo-infra/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net

# Definition of ingress types, versions and subnets
ingress_types:
  # One or more NGINX ingresses with their subnets (can share the same if needed)
  nginx:
    nginx-ingress-internal:
      version: 4.5.2
      subnet_id: /subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/demo-infra/providers/Microsoft.Network/virtualNetworks/cluster01/subnets/aks-inbound-internal
      subnet_name: aks-inbound-internal
    nginx-ingress-external:
      version: 4.5.2
      subnet_id: /subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/demo-infra/providers/Microsoft.Network/virtualNetworks/cluster01/subnets/aks-inbound-external
      subnet_name: aks-inbound-external
  # One or more Azure API Management self-hosted gateways with their subnets (can share the same if needed)
  apim:
    apim-internal:
      api_management_id: /subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/demo-infra/providers/Microsoft.ApiManagement/service/hclhrwrfduhg
      api_management_configuration_endpoint: hclhrwrfduhg.configuration.azure-api.net
      subnet_id: /subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/demo-infra/providers/Microsoft.Network/virtualNetworks/cluster01/subnets/aks-inbound-internal
      subnet_name: aks-inbound-internal

# System node pool configuration
system_nodepool:
  # VM SKU
  node_sku: Standard_D2as_v4
  # Preferably start with 3 nodes
  node_count: 3
  # Should not have less than 2 for HA, preferably 3
  min_count: 3
  # Use more than min if there are custom platform components that autoscale
  max_count: 6
  # Resource ID of network subnet for system nodes
  subnet_id: /subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/demo-infra/providers/Microsoft.Network/virtualNetworks/cluster01/subnets/aks-system

# User node pool configurations for shared nodes, define at least one
shared_nodepools:
  # Name of nodepool, for example standard VM size
  standard:
    # VM SKU
    node_sku: Standard_D4as_v4
    # Starting number of nodes, usualy not 0
    node_count: 0
    # Use 0 if you expect empty cluster is possible (batch workloads)
    min_count: 0
    # Maximum autoscaled nodes in nodepool
    max_count: 2
    # Resource ID of network subnet for this nodepool
    subnet_id: /subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/demo-infra/providers/Microsoft.Network/virtualNetworks/cluster01/subnets/aks-shared
  # Additional nodepools to provide differentiated SKUs, eg. high memory configuration
  highmem:
    # VM SKU
    node_sku: Standard_E4as_v4
    # You might start with 0 nodes if you expect previous nodepool to be enough most of the time
    node_count: 0
    # Use 0 for scale-to-zero
    min_count: 0
    # Maximum autoscaled nodes in nodepool
    max_count: 2
    # Resource ID of network subnet for this nodepool
    subnet_id: /subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/demo-infra/providers/Microsoft.Network/virtualNetworks/cluster01/subnets/aks-shared

# Definitions of applications in classes 1-3 that will leverage shared nodepools
standard_applications:
  # Application inventory ID
  sas101:
    # Map of users with read access to resources of this application
    permanent_readers:
      # Friendly name (used for clarity)
      aks-u1:
        # Object ID of this user as per AAD (this is also called principal ID)
        object_id: 39bb675c-f6a2-48c9-b809-9fb8825ec30e
        # PLACEHOLDER - indicates use can be promoted to writers using AAD PIM (need to be AAD Group based solution)
        eligible_for_write_elevation: true
      aks-u2:
        object_id: c136f236-5ca2-4f28-bf14-00f55f383c85
        eligible_for_write_elevation: false
    # Map of users with write access to resources of this application
    permanent_writers:
      aks-u3:
        object_id: c153cfa5-82b3-409e-a95f-45741a070362
      aks-u4:
        object_id: ab83def6-3f08-42b0-90c2-0332ee48fca3
    # Allowed one or more ingress_types defined above - this causes network policy to filter traffic accordingly
    ingress_types:
      - nginx-ingress-internal
      - apim-internal
    # OPTIONALLY provide list of security policy exclusions   
    policy_exclusions:
      # You can override allowed image regex list which will replace default one - can be more or less restrictive depending on application needs
      allowed_images_override:
      - "docker.io/.+"
      - "mcr.microsoft.com/.+"
      # Name of policy as per policies.tf file
      no_priv_containers:
        # Set this to true to disable this policy for this application. Set to false or do not include here if policy should stay active
        exclude_whole_namespace: false
        # Where possible you can make exceptions on per-image basis (see policy.tf for details what policies support this)
        image_exclusions:
        - docker.io/registry1/image1*
        - docker.io/registry2/*
      # Example of another policy
      https_ingress_only:
        exclude_whole_namespace: true
      limit_volumes:
        exclude_whole_namespace: false
        image_exclusions:
        - docker.io/registry1/image1*
        - docker.io/registry2/*
      no_priv_escalation:
        exclude_whole_namespace: true
      no_sysctl:
        exclude_whole_namespace: true
      no_sysadmin_cap:
        exclude_whole_namespace: false
        image_exclusions:
        - docker.io/registry1/image1*
        - docker.io/registry2/*
      no_external_lb:
        exclude_whole_namespace: true
      no_api_credentials:
        exclude_whole_namespace: false
        image_exclusions:
        - docker.io/registry1/image1*
        - docker.io/registry2/*
  sas102:
    permanent_readers:
      aks-u1:
        object_id: 39bb675c-f6a2-48c9-b809-9fb8825ec30e
        eligible_for_write_elevation: false
    permanent_writers:
      aks-u4:
        object_id: ab83def6-3f08-42b0-90c2-0332ee48fca3
    eligible_writers: {}
    ingress_types:
      - nginx-ingress-internal
    policy_exclusions:
      allowed_images_override:
      - "mcr.microsoft.com/.+"
      no_priv_containers:
        exclude_whole_namespace: true
        image_exclusions:
        - docker.io/registry1/image1*
        - docker.io/registry2/*
      limit_volumes:
        exclude_whole_namespace: true
      no_priv_escalation:
        exclude_whole_namespace: false
        image_exclusions:
        - docker.io/registry2/*
      no_root_containers:
        exclude_whole_namespace: false
        image_exclusions:
        - docker.io/registry2/*
      something:
        exclude_whole_namespace: true
  sas103:
    permanent_readers:
      aks-u4:
        object_id: ab83def6-3f08-42b0-90c2-0332ee48fca3
        eligible_for_write_elevation: true
    permanent_writers:
      aks-u3:
        object_id: c153cfa5-82b3-409e-a95f-45741a070362
    ingress_types:
      - nginx-ingress-external
# Definitions of class 4 applications that will have dedicated nodepool
confidential_applications:
  # Application inventory ID
  sas201:
    # VM SKU
    node_sku: Standard_D2as_v4
    # Initial node count, setting this to 0 will lead to 5 minute delay before first pod is scheduled when team deploy something
    node_count: 1
    # Use 0 if you expect empty cluster is possible (batch workloads)
    min_count: 1
    # Maximum autoscaled nodes in nodepool, can be used to cap costs, but preferably keep it higher than minimum
    max_count: 1
    # Map of users with read access to resources of this application
    permanent_readers:
      # Friendly name (used for clarity)
      aks-u1:
        # Object ID of this user as per AAD (this is also called principal ID)
        object_id: 39bb675c-f6a2-48c9-b809-9fb8825ec30e
        # PLACEHOLDER - indicates use can be promoted to writers using AAD PIM (need to be AAD Group based solution)
        eligible_for_write_elevation: false
    # Map of users with write access to resources of this application
    permanent_writers:
      aks-u4:
        object_id: ab83def6-3f08-42b0-90c2-0332ee48fca3
    # Allowed one or more ingress_types defined above - this causes network policy to filter traffic accordingly
    ingress_types:
      - nginx-ingress-internal
      - apim-internal
    # OPTIONALLY provide list of security policy exclusions
    policy_exclusions:
      no_priv_containers:
        exclude_whole_namespace: false
        image_exclusions:
        - docker.io/registry1/image1*
        - docker.io/registry2/*
    # Resource ID of network subnet for dedicated nodepool
    subnet_id: /subscriptions/d3b7888f-c26e-4961-a976-ff9d5b31dfd3/resourceGroups/demo-infra/providers/Microsoft.Network/virtualNetworks/cluster01/subnets/s201

```

Type: `any`

### <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id)

Description: ID of resource group where cluster will be deployed

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Name of resource group where cluster will be deployed

Type: `string`

## Optional Inputs

No optional inputs.

## Resources

No resources.

## Outputs

The following outputs are exported:

### <a name="output_runtime"></a> [runtime](#output\_runtime)

Description: n/a

<!-- markdownlint-enable -->

<!-- END_TF_DOCS -->