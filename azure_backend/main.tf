resource "azurerm_resource_group" "backend_resource_group" {
  name     = "backend_resource_group"
  location = "West Europe"
}

resource "azurerm_storage_account" "state_storage_account" {
  name                     = "backendterraformwlas"
  resource_group_name      = azurerm_resource_group.backend_resource_group.name
  location                 = azurerm_resource_group.backend_resource_group.location
  account_kind = "StorageV2"
  account_tier = "Standard"
  access_tier = "Hot"
  account_replication_type = "ZRS"
  enable_https_traffic_only = true
  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "state_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.state_storage_account.name
  container_access_type = "blob"
  depends_on = [azurerm_storage_account.state_storage_account]
}