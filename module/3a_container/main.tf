# Storage account  Dependency needed
resource "azurerm_storage_container" "strcont" {
  for_each = var.varstrcontmap
  name = each.key
  storage_account_name = each.value.storage_account_name
  container_access_type = each.value.container_access_type
}