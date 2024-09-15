# For creating App Gateway, Need Dependency of VNET, Subnet, publicip,VM
# public IP for frontendIP
# backend_address_pool
# network_interface_backend_address_pool_association
# azurerm_lb_probe
# azurerm_lb_rule
# Data block Needed for existing resources
# The backend_address_pool, backend_http_settings, http_listener, private_link_configuration, request_routing_rule, redirect_configuration, probe, ssl_certificate, and frontend_port

data "azurerm_virtual_network" "appgwvnet" {
     for_each = var.varappgatmap
  name = each.value.vnetname
  resource_group_name = each.value.resource_group_name
}

data "azurerm_subnet" "datasubnet" {
    for_each = var.varappgatmap
  name = each.value.subnetname
  virtual_network_name = each.value.virtual_network_name
  resource_group_name = each.value.resource_group_name
}
resource "azurerm_public_ip" "pipappgw" {
    for_each = var.varappgatmap
  name                = each.value.pipforappgat
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "motovnetbeap"
  frontend_port_name             = "motovnetfeport"
  frontend_ip_configuration_name = "motovnetfeip"
  http_setting_name              = "motovnetbe-htst"
  listener_name                  = "motovnethttplstn"
  request_routing_rule_name      = "motovnetrqrt"
  redirect_configuration_name    = "motovnetrdrcfg"
}

resource "azurerm_application_gateway" "agggwnet" {
  for_each = var.varappgatmap  
  name                = each.key
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  sku {
    name     = each.value.skuname
    tier     = each.value.skutier
    capacity = each.value.skucapacity
  }

  gateway_ip_configuration {
    name      = each.value.gatewayipconfname
    subnet_id = data.azurerm_subnet.datasubnet[each.key].id
  }

  frontend_port {
    name = local.frontend_port_name
    port = each.value.frontendport
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pipappgw[each.key].id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = each.value.cookie_based_affinity
    path                  = each.value.path
    port                  = each.value.backendport
    protocol              = each.value.protocol
    request_timeout       = each.value.request_timeout
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = each.value.protocol
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = each.value.priority
    rule_type                  = each.value.rule_type
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}