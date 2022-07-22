terraform {
  backend "azurerm" {
      storage_account_name = "backendterraformwlas"
      container_name       = "tfstate"
      key                  = "dev.terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.14.0"
    }
  }

}

provider "azurerm" {
  features {}
}