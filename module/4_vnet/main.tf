# Resource group  Dependency needed
resource "azurerm_virtual_network" "vnet" {
  for_each = var.varvnetmap
  name = each.key
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space = each.value.address_space
}