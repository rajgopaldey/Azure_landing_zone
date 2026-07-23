terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    azuread = {     #I need to register one provider in azure ad for service principle management
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  #This block is a azurerm central control plane
  # IT control when resource deletion time lifecycle management
  features {
    key_vault {
      #when we run terrafor destroy keyvault is not deleted permenately save for 90dys
      purge_soft_delete_on_destroy = true
      #after deletion if want to create kevault again it will show already exixt agin we can 
      #recover this keyvault
      recover_soft_deleted_key_vaults = true
    }
  }

  subscription_id = "f9c7ace2-d427-4446-b471-079f5693715c"
}

provider "azuread" {}
#in Prod it will be false then this feature will waork in dev/test it will true