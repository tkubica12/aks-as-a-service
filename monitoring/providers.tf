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
    random = {
      source  = "hashicorp/random"
      version = "~>3"
    }
    # helm = {
    #   source  = "hashicorp/helm"
    #   version = "~>2"
    # }
    # local = {
    #   source  = "hashicorp/local"
    #   version = "~>2"
    # }
  }
  backend "azurerm" {
    resource_group_name  = "base"
    storage_account_name = "tkubicastore"
    container_name       = "tfstate"
    key                  = "aksaas.monitoring.tfstate"
    subscription_id      = "d3b7888f-c26e-4961-a976-ff9d5b31dfd3"
    use_oidc             = true
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
  subscription_id = "d3b7888f-c26e-4961-a976-ff9d5b31dfd3"
}
