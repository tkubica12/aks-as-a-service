terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1"
    }
    time = {
      source  = "hashicorp/time"
      version = "~>0.9"
    }
  }
}
