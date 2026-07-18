
locals {
  common_tags = {
    "ManagedBy"   = "Terraform"
    "Owner"       = "Rajgoapal"
    "Environment" = "dev"
  }
}
module "resource_group" {
  source      = "../../modules/azurerm_resource_group"
  rg_name     = "rg-dev-02"
  rg_location = "Central India"
  rg_tags     = local.common_tags
}

# module "spoke_virtual_network" {
#   depends_on = [module.resource_group]
#   source = "../../modules/azurerm_virtual_network"
#   vnt_name = "vnt-dev-02"
#   vnt_location = "Central India"
#   vnt_resource_group_name = "rg-dev-02"
#   vnt_address_space = ["10.2.0.0/16"]
#   vnt_tags = local.common_tags
# }
# module "subnet" {
# depends_on          = [module.spoke_virtual_network] 
#   source              = "../../modules/azurerm_subnet"
#   resource_group_name = "rg-dev-02"  
#   vnet_name           = "vnt-dev-02"
# #   subnets = {
#     # "web-subnet" = { address_prefix = "10.2.10.0/24" }
#     # "db-subnet"  = { address_prefix = "10.2.20.0/24" }
#     "aks-subnet" = { address_prefix = "10.2.12.0/22" } # dedicated for AKS
#   }
# }

# module "storage_accounr" {
#   depends_on = [module.resource_group]
#   source = "../../modules/azurerm_storage_account"
#   stg_name = "stgdev02989"
#   resource_group_name = "rg-dev-02"
#   location = "Central India"
#   account_tier = "Standard"
#   account_replication_type = "LRS"
#   tags = local.common_tags

# }

module "dev_static_web_app" {
  depends_on          = [module.resource_group]
  source              = "../../modules/azurerm_static_web_app"
  stb_name            = "dev-static-app"
  stb_location        = "eastasia"
  resource_group_name = "rg-dev-02"
  sku_size            = "Free"
  sku_tier            = "Free"

}

module "Dev_acr"{
  source = "../../modules/azurerm_container_registery"
  acr_name = "dev_ac-01"
  resource_group_name = "rg-dev-02"
  location = "central india"
}



# module "aks_cluster" {
#   depends_on          = [module.spoke_virtual_network, module.subnet] 
#   source              = "../../modules/azurerm_kubernetes_cluster" # module source path
#   cluster_name        = "aks-dev-001"
#   location            = "Central India"
#   resource_group_name = "rg-dev-02"
#   dns_prefix          = "aksdev"
#   node_count          = 2
#   vm_size             = "Standard_D2s_v4" 
#   vnet_subnet_id      = module.subnet.subnet_ids["aks-subnet"]
#   tags                = local.common_tags
# }