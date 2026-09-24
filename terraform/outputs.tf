output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "app_subnet_id" {
  value = azurerm_subnet.app.id
}

output "management_subnet_id" {
  value = azurerm_subnet.management.id
}
output "managed_identity_name" {
  value = azurerm_user_assigned_identity.app.name
}

output "key_vault_name" {
  value = azurerm_key_vault.main.name
}

output "function_app_name" {
  value = azurerm_function_app_flex_consumption.app.name
}

output "function_app_hostname" {
  value = azurerm_function_app_flex_consumption.app.default_hostname
}