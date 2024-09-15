# Resource group  Dependency needed
resource "azurerm_storage_account" "str" {
 for_each = var.varstrmap
  name = each.key
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  account_tier = each.value.account_tier
  account_replication_type = each.value.account_replication_type
}