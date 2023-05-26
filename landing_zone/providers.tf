terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3"
    }
    # azapi = {
    #   source  = "azure/azapi"
    #   version = "~>1"
    # }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3"
    }
    # helm = {
    #   source  = "hashicorp/helm"
    #   version = "~>2"
    # }
  }
  backend "azurerm" {
    resource_group_name  = "base"
    storage_account_name = "tkubicastore"
    container_name       = "tfstate"
    key                  = "aksaas.lz.tfstate"
    subscription_id      = "d3b7888f-c26e-4961-a976-ff9d5b31dfd3"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# provider "helm" {
#   kubernetes {
#     host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
#     client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
#     client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)
#     cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
#   }
# }
