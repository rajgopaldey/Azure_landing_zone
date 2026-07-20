resource "azurerm_subnet" "main" {
  for_each             = var.subnets 
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name 
  address_prefixes     = [each.value.address_prefix]

  dynamic "delegation" {
    for_each = each.key == "backend-subnet" ? [1] : []
    
    content {
      name = "aca-delegation"
      service_delegation {
        name    = "Microsoft.App/environments"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
  }
}