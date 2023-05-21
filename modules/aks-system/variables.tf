variable "node_sku" {
  type = string
}

variable "node_count" {
  type    = number
  default = 3
}

variable "min_count" {
  type    = number
  default = 3
}

variable "max_count" {
  type    = number
  default = 3
}

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_id" {
  type = string
}

variable "api_subnet_id" {
  type = string
}

variable "cluster_subnet_id" {
  type = string
}

variable "cluster_private_dns_zone_id" {
  type = string
}

variable "keyvault_private_dns_zone_id" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.24"
}

variable "cluster_upgrade_channel" {
  type    = string
  default = "stable"

  validation {
    condition     = can(regex("^stable$|^patch$|^rapid$|^node-image$|^noneh$", var.cluster_upgrade_channel))
    error_message = "automatic_channel_upgrade must be stable, patch, rapid, node-image or none"
  }
}

variable "cluster_sku" {
  type    = string
  default = "Free"

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
}
