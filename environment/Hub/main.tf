locals {
  common_tags = {
    "ManagedBy"   = "Terraform"
    "Owner"       = "Rajgoapal"
    "Environment" = "dev"
  }
}

module "hub_resource_group" {
  source = "../../modules/azurerm_resource_group"
  rg_name = "rg-hub-001"
  rg_location = "central india"
  rg_tags     = local.common_tags
   }


module "hub_virtual_network" {
    depends_on = [module.hub_resource_group]
    source = "../../modules/azurerm_virtual_network"
    vnt_resource_group_name = "rg-hub-001"
    vnt_name = "vnt-hub-001"
    vnt_location = "central india"
    vnt_address_space = ["10.1.0.0/22"]
    vnt_tags                = local.common_tags
}

module "hub_subnets" {
  depends_on          = [module.hub_virtual_network]
  source              = "../../modules/azurerm_subnet" 
  resource_group_name = "rg-hub-001"
  vnet_name           = "vnt-hub-001"
  subnets = {
    "AzureFirewallSubnet" = { address_prefix = "10.1.0.0/26" }
    "AzureBastionSubnet"  = { address_prefix = "10.1.0.64/26" }
    "GatewaySubnet"       = { address_prefix = "10.1.0.128/26" }
  }
}
module "private_dns" {
  depends_on          = [module.hub_resource_group, module.hub_virtual_network]
  source              = "../../modules/azurerm_private_dns"
  dns_zone_name       = "corp.internal"
  resource_group_name = "rg-hub-001"
  vnet_to_link = {
    #its we comand to the dns crate the link with hub vnet data from line-17
    #vnet-id means go to the hub_virtual_network module and get output of vnet_id
    "hub-vnet"   = module.hub_virtual_network.vnet_id
   # "spoke-vnet" = module.virtual_network.vnet_id    #spoke vnet like dev
  }

  tags = {
    Environment = "Dev"
  }
}

module "azurerm_firewall" {
  depends_on             = [module.hub_resource_group, module.hub_virtual_network]
  source = "../../modules/azurerm_firewall"
  pip_name               = "pip-dev-hub-fw"      
  fw_name                = "fw-dev-hub"          
  fw_location            = "central india"
  fw_resource_group_name = "rg-hub-001"
  fw_subnet_id           = module.hub_subnets.subnet_ids["AzureFirewallSubnet"]
  tags                   = { Environment = "Dev" }
}


module "route_table_dev" { #if trafic want go from dev vnet to hub vnet then it should go to firewall
  depends_on             = [module.hub_resource_group, module.azurerm_firewall]
  source = "../../modules/azurerm_route_table"
  rt_name                = "rt-dev-001"
  rt_location            = "central india"      
  rt_resource_group_name = "rg-hub-001"        
  firewall_private_ip    = module.azurerm_firewall.firewall_private_ip 
  
  tags                   = local.common_tags
}
