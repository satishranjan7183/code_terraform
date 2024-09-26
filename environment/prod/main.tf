# Call Child module for Resource Group 
module "rgmodule" {
  source = "../../module/1_rg"
  varrgmap = var.varrgmapmodule
  # varrglocation = var.varrglocationmodule
}

# Call Child module for Key Vault 
module "kvmodule" {
  source     = "../../module/2_keyvault"
  varkvmap   = var.varkvmapmodule
  depends_on = [module.rgmodule]
}

# Call Child module for Storage Account
module "strmodule" {
  source     = "../../module/3_storageaccount"
  varstrmap  = var.varstrmapmodule
  depends_on = [module.rgmodule]
}

# Call Child module for Container
module "strcontmodule" {
  source        = "../../module/3a_container"
  varstrcontmap = var.varstrcontmapmodule
  depends_on    = [module.strmodule]
}

# Call Child module for Virtual Network
module "vnetmodule" {
  source     = "../../module/4_vnet"
  varvnetmap = var.varvnetmapmodule
  depends_on = [module.rgmodule]
}

# Call Child module for Subnet
module "subnetmodule" {
  source     = "../../module/4a_subnet"
  varsubmap  = var.varsubmapmodule
  depends_on = [module.vnetmodule]
}

# Call Child module for Public IP (Not Neccassary)
# module "pipmodule" {
#   source     = "../../module/5_pubip"
#   varpipmap  = var.varpipmapmodule
#   depends_on = [module.rgmodule]
# }

# Call Child module for vm
module "vmmodule" {
  source     = "../../module/6_vm"
  varvm      = var.varvmmodule
  depends_on = [module.subnetmodule]
}
# Call Child module for bastion
module "bastionmodule" {
  source        = "../../module/7_bastion"
  varbastionmap = var.varbastionmapmodule
  #   depends_on    = [module.vmmodule, module.pipmodule]
  depends_on = [module.vmmodule]
}

# Call Child module for Load Balancer
module "lbmodule" {
  source     = "../../module/8_lb"
  varlbmap   = var.varlbmapmodule
  depends_on = [module.bastionmodule]
}

module "varappgatmap" {
  source       = "../../module/9_appgw"
  varappgatmap = var.varappgatmapmodule
  depends_on   = [module.subnetmodule]
}

module "nsgmodue" {
  source     = "../../module/10_nsg"
  varnsgmap  = var.varnsgmapmodule
  depends_on = [module.rgmodule]
}