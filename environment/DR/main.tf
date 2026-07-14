locals {
  common_tags = {
    "ManagedBy"   = "Terraform"
    "Owner"       = "Rajgoapal"
    "Environment" = "dr"
}
}
module "dr_resource_group" {
    source = "..//../modules/azurerm_resource_group"
    rg_name = "rg_dr-02"
    rg_location = "south India"
    rg_tags = local.common_tags
}
module "dr_virtual_network"{
    source ="../../modules/azurerm_virtual_network"
    vnt_name = "vnet_dr_02"
    vnt_location = "south_india"
    vnt_resource_group_name = "rg_dr-02"
    vnt_address_space = ["10.1.0.0/16"]
    vnt_tags = local.common_tags

}