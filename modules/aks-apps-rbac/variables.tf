variable "name" {
  type        = string
  description = "Name of application"
}
variable "permanent_readers" {
  description = "Map of Azure AD object IDs that will have read access to the application."
}

variable "permanent_writers" {
  description = "Map of Azure AD object IDs that will have write access to the application."
}

variable "cluster_id" {
  type        = string
  description = "Cluster resource ID"
}

variable "cluster_subnet_id" {
  type        = string
  description = "ID of subnet where system nodes are deployed"
}

variable "oidc_issuer_url" {
  type        = string
  description = "Cluster issuer URL for OIDC"
}

variable "namespace" {
  type        = string
  description = "Name of namespace - for practical reasons the same name as application name is recommended"
}

variable "location" {
  type        = string
  description = "Azure region of cluster such as westeurope, northeurope or swedencentral"
}

variable "resource_group_name" {
  type        = string
  description = "Name of resource group where cluster is deployed"
}

variable "keyvault_private_dns_zone_id" {
  type        = string
  description = "ID of existing private DNS zone for keyvault for private endpoints"
}
