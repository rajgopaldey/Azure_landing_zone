resource "azurerm_virtual_network" "vnet" {
    name = var.vnt_name
    location = var.vnt_location
    resource_group_name = var.vnt_resource_group_name
    address_space = var.vnt_address_space
    tags=var.vnt_tags
    }



# /16 = 65,536
# /17 = 32,768
# /18 = 16,384
# /19 = 8,192
# /20 = 4,096
# /21 = 2,048
# /22 = 1,024 ✅
# /23 = 512
# /24 = 256
# /25 = 128
# /26 = 64
# /27 = 32
# /28 = 16
# /29 = 8
  
