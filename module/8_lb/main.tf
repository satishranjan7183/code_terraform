# For creating Load Balancer, Need Dependency of RG, VNET, Subnet, publicip,VM
# public IP for frontendIP
# backend_address_pool
# network_interface_backend_address_pool_association
# azurerm_lb_probe
# azurerm_lb_rule
# Data block Needed for existing resources

resource "azurerm_public_ip" "piplb" {
  for_each = var.varlbmap
  name = each.value.pipnamelb
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method = each.value.allocation_method
}

resource "azurerm_lb" "lb" {
 for_each = var.varlbmap
  name = each.key
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  frontend_ip_configuration {
    name = each.value.frontendipname
    public_ip_address_id = azurerm_public_ip.piplb[each.key].id
  }
}

resource "azurerm_lb_backend_address_pool" "netflixbackendpool" {
    for_each = var.varlbmap
  loadbalancer_id = azurerm_lb.lb[each.key].id
  name            = each.value.backendpoolname
}

data "azurerm_network_interface" "vm1nic" {
    for_each = var.varlbmap
  name = each.value.vm1nicname
  resource_group_name = each.value.resource_group_name
}

data "azurerm_network_interface" "vm2nic" {
    for_each = var.varlbmap
  name = each.value.vm2nicname
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_network_interface_backend_address_pool_association" "vm1backend" {
     for_each = var.varlbmap
  network_interface_id = data.azurerm_network_interface.vm1nic[each.key].id
  backend_address_pool_id = azurerm_lb_backend_address_pool.netflixbackendpool[each.key].id
  ip_configuration_name = each.value.ipconfigurationforvm1
}

resource "azurerm_network_interface_backend_address_pool_association" "vm2backend" {
  for_each = var.varlbmap
  network_interface_id = data.azurerm_network_interface.vm2nic[each.key].id
  backend_address_pool_id = azurerm_lb_backend_address_pool.netflixbackendpool[each.key].id
  ip_configuration_name = each.value.ipconfigurationforvm2
}

resource "azurerm_lb_probe" "lbprobe" {
    for_each = var.varlbmap
  name = each.value.probename
  port = each.value.port
  loadbalancer_id = azurerm_lb.lb[each.key].id
}

resource "azurerm_lb_rule" "lbrulenetflix" {
  for_each = var.varlbmap
  name = each.value.lbrulename
  loadbalancer_id = azurerm_lb.lb[each.key].id
  frontend_port = each.value.frontend_port
  backend_port = each.value.backend_port
  protocol = each.value.protocol
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.netflixbackendpool[each.key].id]
  probe_id = azurerm_lb_probe.lbprobe[each.key].id
}