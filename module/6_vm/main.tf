# For creating VM, Need Dependency of RG, VNET, Subnet, NIC, if needed to use keyvault, use to keyvault
data "azurerm_subnet" "datasub" {
  for_each = var.varvm
  name = each.value.subnetname
  resource_group_name = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
}

resource "azurerm_network_interface" "netint" {
    for_each = var.varvm
  name = each.value.nicname
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  ip_configuration {
    name = each.value.subnetname
    private_ip_address_allocation = each.value.private_ip_address_allocation
    subnet_id = data.azurerm_subnet.datasub[each.key].id
  }
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
    for_each = var.varvm
  name = each.key
  resource_group_name = each.value.resource_group_name
  location = each.value.location
  size = each.value.size
  network_interface_ids = [azurerm_network_interface.netint[each.key].id,]
  admin_username = each.value.admin_username
  admin_password = each.value.admin_password
  disable_password_authentication = each.value.disable_password_authentication
  os_disk {
    caching = each.value.caching
    storage_account_type = each.value.storage_account_type
  }

  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }
}

