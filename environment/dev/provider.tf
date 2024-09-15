terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.1.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "6e6cd149-526b-49f2-a0c7-be7a29a5b76c"
}