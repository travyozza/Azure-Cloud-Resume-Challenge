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

  name = "etwncfus"

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document = "index.html"
  }
}

resource "azurerm_storage_blob" "resume_html" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.crc-storage-account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "../frontend/index.html"
}

resource "azurerm_storage_blob" "styles_css" {
  name                   = "styles.css"
  storage_account_name   = azurerm_storage_account.crc-storage-account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/css"
  source                 = "../frontend/styles.css"
}

resource "azurerm_cdn_profile" "crc-cdn-profile" {
  name                = "crc-cdn-profile"
  resource_group_name = azurerm_resource_group.crc-rg.name
  location            = var.location
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "crc-cdn-endpoint" {
  name                = "crc-cdn-endpoint"
  profile_name        = azurerm_cdn_profile.crc-cdn-profile.name
  resource_group_name = azurerm_resource_group.crc-rg.name
  location            = var.location

  origin_host_header = azurerm_storage_account.crc-storage-account.primary_web_host
  origin {
    name      = "crc-origin"
    host_name = azurerm_storage_account.crc-storage-account.primary_web_host
  }
}
