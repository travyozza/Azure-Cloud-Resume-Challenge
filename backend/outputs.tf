output "resource_group_name" {
  value = azurerm_resource_group.crc-rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.crc-storage-account.name
}

output "primary_web_host" {
  value = azurerm_storage_account.crc-storage-account.primary_web_host
}