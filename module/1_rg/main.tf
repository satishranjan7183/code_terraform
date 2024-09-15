# RG is neccessary to create all other resources in azure
resource "azurerm_resource_group" "rg" {
  for_each = var.varrgmap
  name = each.key
  location = each.value
}