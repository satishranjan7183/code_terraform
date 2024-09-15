# For creating Bastion, Need Dependency of RG, VNET, Subnet, publicip,VM.
data "azurerm_subnet" "datasubnet" {
  for_each = var.varbastionmap
  name = each.value.bastionsubnetname
  virtual_network_name = each.value.virtual_network_name
  resource_group_name = each.value.resource_group_name
}
# data "azurerm_public_ip" "datapip" {
#   for_each = var.varbastionmap  
#   name = each.value.pubipnamebastion
#   resource_group_name = each.value.resource_group_name
# }

resource "azurerm_public_ip" "pip" {
  for_each = var.varbastionmap
  name = each.value.pipname
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method = each.value.allocation_method
}

resource "azurerm_bastion_host" "name" {
  for_each = var.varbastionmap
  name = each.key
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  ip_configuration {
    name = each.value.bastionsubnetname
    subnet_id = data.azurerm_subnet.datasubnet[each.key].id
    # public_ip_address_id = data.azurerm_public_ip.datapip[each.key].id
    public_ip_address_id = azurerm_public_ip.pip[each.key].id
}
}