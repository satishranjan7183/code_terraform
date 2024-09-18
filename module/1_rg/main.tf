# RG is neccessary to create all other resources in azure
resource "azurerm_resource_group" "rg" {
   for_each = var.varrgmap
  # for_each = var.varrglocation
  name = each.key
  # name = "rg-${terraform.workspace}"
  location = each.value
}