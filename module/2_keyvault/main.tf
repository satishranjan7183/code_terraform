# Resource group  Dependency needed
# For existing tenant id, need to add data module for azurerm_client_config, this will bring tenantid, subscriptionid, objectid 
data "azurerm_client_config" "kvclientconfig" {}
resource "azurerm_key_vault" "keyvault" {
    for_each = var.varkvmap
  name = each.key
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name = each.value.sku_name
  tenant_id = data.azurerm_client_config.kvclientconfig.tenant_id
  soft_delete_retention_days  = each.value.soft_delete_retention_days
  purge_protection_enabled = each.value.purge_protection_enabled
  enabled_for_disk_encryption = each.value.enabled_for_disk_encryption
   access_policy {
    tenant_id = data.azurerm_client_config.kvclientconfig.tenant_id
    object_id = data.azurerm_client_config.kvclientconfig.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get","Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}