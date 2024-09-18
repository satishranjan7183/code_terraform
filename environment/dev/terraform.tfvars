varrgmapmodule = {
  motorg = "canada central"
}
varkvmapmodule = {
  motokv = {
    location                    = "canada central"
    resource_group_name         = "motorg"
    sku_name                    = "standard"
    soft_delete_retention_days  = 7
    purge_protection_enabled    = "false"
    enabled_for_disk_encryption = "true"
  }
}

varstrmapmodule = {
  motostr = {
    location                 = "canada central"
    resource_group_name      = "motorg"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

varstrcontmapmodule = {
  motostrcont = {
    storage_account_name  = "motostr"
    container_access_type = "private"
  }
}

varvnetmapmodule = {
  motovnet = {
    location            = "canada central"
    resource_group_name = "motorg"
    address_space       = ["10.0.0.0/16"]
  }
}

varsubmapmodule = {
  # Subnet for VM
  motosubvm = {
    resource_group_name  = "motorg"
    virtual_network_name = "motovnet"
    address_prefixes     = ["10.0.0.0/24"]
  }
  # Subnet for AzureBastion
  AzureBastionSubnet = {
    resource_group_name  = "motorg"
    virtual_network_name = "motovnet"
    address_prefixes     = ["10.0.1.0/24"]
  }
  # Subnet for App Gateway
  motoappgatewaysubnet = {
    resource_group_name  = "motorg"
    virtual_network_name = "motovnet"
    address_prefixes     = ["10.0.2.0/24"]
  }
}

# varpipmapmodule = {
#   # public IP for Bastion Host
#   motopipbastion = {
#     location            = "canada central"
#     resource_group_name = "motorg"
#     allocation_method   = "Static"
#   }
# }

varvmmodule = {
  motovm1 = {
    resource_group_name             = "motorg"
    location                        = "canada central"
    size                            = "Standard_F2"
    admin_username                  = "adminuser"
    admin_password                  = "adminuser123@"
    disable_password_authentication = "false"
    caching                         = "ReadWrite"
    storage_account_type            = "Standard_LRS"
    nicname                         = "motonicvm1"
    subnetname                      = "motosubvm"
    private_ip_address_allocation   = "Dynamic"
    virtual_network_name            = "motovnet"
    publisher                       = "Canonical"
    offer                           = "0001-com-ubuntu-server-jammy"
    sku                             = "22_04-lts"
    version                         = "latest"
  }

  motovm2 = {
    resource_group_name             = "motorg"
    location                        = "canada central"
    size                            = "Standard_F2"
    admin_username                  = "adminuser"
    admin_password                  = "adminuser123@"
    disable_password_authentication = "false"
    caching                         = "ReadWrite"
    storage_account_type            = "Standard_LRS"
    nicname                         = "motonicvm2"
    subnetname                      = "motosubvm"
    private_ip_address_allocation   = "Dynamic"
    virtual_network_name            = "motovnet"
    publisher                       = "Canonical"
    offer                           = "0001-com-ubuntu-server-jammy"
    sku                             = "22_04-lts"
    version                         = "latest"
  }
}

varbastionmapmodule = {
  motobastion = {
    location             = "canada central"
    resource_group_name  = "motorg"
    bastionsubnetname    = "AzureBastionSubnet"
    virtual_network_name = "motovnet"
    resource_group_name  = "motorg"
    # pubipnamebastion     = "motopipbastion"
    pipname           = "motopipbastion"
    allocation_method = "Static"
  }
}

varlbmapmodule = {
  motolb = {
    location                       = "canada central"
    resource_group_name            = "motorg"
    frontendipname                 = "netflixfrontend"
    backendpoolname                = "netflixbackend"
    vm1nicname                     = "motonicvm1"
    vm2nicname                     = "motonicvm2"
    ipconfigurationforvm1          = "motosubvm"
    ipconfigurationforvm2          = "motosubvm"
    probename                      = "netflixprobe"
    port                           = 80
    lbrulename                     = "netflixrule"
    frontend_port                  = 80
    backend_port                   = 80
    protocol                       = "Tcp"
    frontend_ip_configuration_name = "netflixfrontend"
    pipnamelb                      = "frontendpubip"
    allocation_method              = "Static"
    pipnamelb                      = "lbpip"
  }
}

varappgatmapmodule = {
  motoappgw = {
    resource_group_name   = "motorg"
    location              = "canada central"
    skuname               = "Standard_v2"
    skutier               = "Standard_v2"
    skucapacity           = 2
    gatewayipconfname     = "my-gateway-ip-configuration"
    frontendport          = 80
    cookie_based_affinity = "Disabled"
    backendport           = 80
    protocol              = "Http"
    request_timeout       = 60
    path                  = "/path1/"
    priority              = 9
    rule_type             = "Basic"
    vnetname              = "motovnet"
    subnetname            = "motoappgatewaysubnet"
    virtual_network_name  = "motovnet"
    pipforappgat          = "publicipappgw"
    allocation_method     = "Static"
    frontendport          = 80
  }
}

varnsgmapmodule = {
  motonsg = {
    location                   = "canada central"
    resource_group_name        = "motorg"
    securityrulename           = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}