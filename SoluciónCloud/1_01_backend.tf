terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-01"
    storage_account_name = "tfstatedevops01"
    container_name       = "tfstates"
    key                  = "azu-demolab-dev_op.tfstate"
  }
}