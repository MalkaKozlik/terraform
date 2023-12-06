terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-tf-state-mk"
    storage_account_name = "sttfstatemk"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = "a173eef2-33d7-4d55-b0b5-18b271f8d42b"
}

resource "azurerm_resource_group" "state_resource_group" {
  name     = "rg-tf-state-mk"
  location = "West Europe"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "sttfstatemk"
  resource_group_name      = azurerm_resource_group.state_resource_group.name
  location                 = azurerm_resource_group.state_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}


