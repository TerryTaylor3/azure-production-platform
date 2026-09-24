resource "azurerm_storage_account" "function" {
  name                     = "azprodfn${local.key_vault_suffix}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version = "TLS1_2"
}

resource "azurerm_storage_container" "function_deploy" {
  name                  = "function-deploy"
  storage_account_id    = azurerm_storage_account.function.id
  container_access_type = "private"
}

resource "azurerm_service_plan" "function" {
  name                = "azure-production-function-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  os_type  = "Linux"
  sku_name = "FC1"
}

resource "azurerm_function_app_flex_consumption" "app" {
  name                = "azureprod-fn-${local.key_vault_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  service_plan_id = azurerm_service_plan.function.id

  storage_container_type      = "blobContainer"
  storage_container_endpoint  = "${azurerm_storage_account.function.primary_blob_endpoint}${azurerm_storage_container.function_deploy.name}"
  storage_authentication_type = "StorageAccountConnectionString"
  storage_access_key          = azurerm_storage_account.function.primary_access_key

  runtime_name    = "python"
  runtime_version = "3.11"

  maximum_instance_count = 2
  instance_memory_in_mb  = 2048

  virtual_network_subnet_id = azurerm_subnet.app.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app.id]
  }

  site_config {}

  app_settings = {
    KEY_VAULT_URI = azurerm_key_vault.main.vault_uri
  }
}