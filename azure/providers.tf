terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.15.0, < 5.0.0"
    }
  }
}

provider "azurerm" {
  features {
  key_vault {
    purge_soft_delete_on_destroy = true
  }

  resource_group {
    prevent_deletion_if_contains_resources = true
  }
}

  use_cli = true
}
