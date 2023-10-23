variable "node_sku" {
  type = string
  description = "VM SKU for system AKS nodes such as Standard_D4ads_v5"
}

variable "node_count" {
  type    = number
  default = 3
  description = "Initial count of system nodes"
}

variable "min_count" {
  type    = number
  default = 3
  description = "Minimum count of system nodes"
}

variable "max_count" {
  type    = number
  default = 3
  description = "Maximum count of system nodes"
}

variable "name" {
  type = string
  description = "Name of cluster"
}

variable "location" {
  type = string
  description = "Azure region of cluster such as westeurope, northeurope or swedencentral"
}

variable "resource_group_name" {
  type = string
  description = "Name of resource group where cluster is deployed"
}

variable "resource_group_id" {
  type = string
  description = "ID of resource group where cluster is deployed"
}

variable "api_subnet_id" {
  type = string
  description = "ID of subnet where API server is deployed"
}

variable "cluster_subnet_id" {
  type = string
  description = "ID of subnet where system nodes are deployed"
}

variable "cluster_private_dns_zone_id" {
  type = string
  description = "ID of existing private DNS zone for cluster - used for private cluster feature"
}

variable "keyvault_private_dns_zone_id" {
  type = string
  description = "ID of existing private DNS zone for keyvault for private endpoints"
}

variable "cluster_version" {
  type    = string
  default = "1.24"
  description = "Cluster version such as 1.24.1 for specific version or 1.24 for latest patch version"
}

variable "cluster_upgrade_channel" {
  type    = string
  default = "stable"
  description = "Channel for automatic cluster upgrades such as stable, patch, rapid, node-image or none"

  validation {
    condition     = can(regex("^stable$|^patch$|^rapid$|^node-image$|^noneh$", var.cluster_upgrade_channel))
    error_message = "automatic_channel_upgrade must be stable, patch, rapid, node-image or none"
  }
}

variable "cluster_sku" {
  type    = string
  default = "Free"
  description = "SKU for cluster such as Free or Standard, for production Standard is recommended"

  validation {
    condition     = can(regex("^Free$|^Standard$", var.cluster_sku))
    error_message = "Cluster SKU mush be Free or Standard"
  }
}

variable "standard_applications" {} # TBD schema validation

variable "confidential_applications" {} # TBD schema validation

variable "cluster_admin_principal_id" {
  type    = string
  default = "b0797e57-4a37-4f7d-9def-b312831bc3d7"
}

variable "shared_nodepools" { # TBD schema validation

}

variable "ingress_types" { # TBD schema validation

}

variable "log_analytics_id_defender" {
  type = string
  description = "ID of existing log analytics workspace for Azure Defender for Kubernetes"
}

variable "prometheus_dce_id" {
  type = string
  description = "Azure Data Collection Endpoint ID for collecting Prometheus metrics"
  default = ""
}
