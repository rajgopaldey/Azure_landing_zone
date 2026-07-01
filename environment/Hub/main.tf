module "hub_resource_group" {
  source = "../../modules/resource_group"
  rg_name = "rg-hub-002"
  rg_location = "central india"
  rg_tags     = local.common_tags
   }


module "hub_virtual_netork" {
    depends_on = [module.hub_resource_group]
    source = "..//..//modules/azurerm_virtual_network"
    vnt_resource_group_name = "rg-hub-002"
    vnt_name = "vnt-hub-002"
    vnt_location = "central india"
    vnt_address_space = ["10.1.0.0/22"]
    vnt_tags                = local.common_tags

}
