variable "resource_group_name" {
  type        = string
  description = <<EOF
The name of the resource group in which to create platform monitoring resources.
EOF
}

variable "location" {
  type        = string
  description = <<EOF
The Azure region in which to create platform monitoring resources.
EOF
}

variable "monitor_workspace_name" {
  type        = string
  description = <<EOF
The name of the Azure Monitor workspace to create.
EOF
}

variable "grafana_name" {
  type        = string
  description = <<EOF
The name of the Azure Managed Grafana to create.
EOF
}

variable "ampls_name" {
  type        = string
  description = <<EOF
Name of AMPLS instance to connect to.
EOF
}

variable "ampls_rg_name" {
  type        = string
  description = <<EOF
Name of resource group containing AMPLS instance.
EOF
}
