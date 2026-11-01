output "resource_group_name" {
  description = "Demo resource group name"
  value       = azurerm_resource_group.demo.name
}
output "virtual_network_id" {
  description = "Virtual network resource ID"
  value       = azurerm_virtual_network.demo.id
}
output "app_subnet_id" {
  description = "App subnet resource ID"
  value       = azurerm_subnet.app.id
}
output "ops_subnet_id" {
  description = "Operations subnet resource ID"
  value       = azurerm_subnet.ops.id
}
output "storage_account_name" {
  description = "Storage account with public network access disabled"
  value       = azurerm_storage_account.demo.name
}
