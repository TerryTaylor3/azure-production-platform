terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "azure-production-tfstate-rg"
    storage_account_name = "azprodtfstateb0b337"
    container_name       = "tfstate"
    key                  = "production.tfstate"

    use_azuread_auth = true
  }
}

provider "azurerm" {
  features {}
}