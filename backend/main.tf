data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "crc-rg" {
  name     = "crc-rg"
  location = var.location
}

# Generate random value for the storage account name
resource "random_string" "storage_account_name" {
  length  = 8
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_storage_account" "crc-storage-account" {
  resource_group_name = azurerm_resource_group.crc-rg.name
  location            = var.location

  name = random_string.storage_account_name.result

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document = "index.html"
  }
}

resource "azurerm_storage_blob" "example" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.crc-storage-account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "../frontend/index.html"
}



