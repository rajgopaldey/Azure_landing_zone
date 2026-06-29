
locals {
  common_tags = {
    "ManagedBy"   = "Terraform"
    "Owner"       = "Rajgoapal"
    "Environment" = "dev"
  }
}

######################################

module "resource_group" {
  source      = "../../modules/azurerm_resource_group"
  rg_name     = "rg-dev-001"
  rg_location = "Central India"
  rg_tags     = local.common_tags
}

module "virtual_network" {
  depends_on = [module.resource_group]
  source = "../../modules/azurerm_virtual_netork"
  vnt_name = "vnt-dev-001"
  vnt_location = "Central India"
  vnt_resource_group_name = "rg-dev-001"
  vnt_address_space = ["10.0.0.0/22"]
  vnt_tags = local.common_tags

  
}


module "subnet" {
depends_on = [module.resource_group]
  source = "../../modules/azurerm_subnet"
  sub_name = "sub-dev-001"
  resource_group_name = "rg-dev-001"  
  vnet_name = "vnt-dev-001"
  address_prefixes = ["10.0.0.0/24"]
}

module "storage_accounr" {
  depends_on = [module.resource_group]
  source = "../../modules/azurerm_storage_account"
  stg_name = "stgdev001989"
  resource_group_name = "rg-dev-001"
  location = "Central India"
  account_tier = "Standard"
  account_replication_type = "LRS"
  tags = local.common_tags
  
}