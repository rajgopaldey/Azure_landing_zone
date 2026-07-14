resource "azurerm_public_ip" "pip" {
    name= var.pip_name
    location = var.fw_location
    resource_group_name = var.fw_resource_group_name   # we ill create pip one time rg for firewall and pip is same
    allocation_method   = "Static" 
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall" "fw" {
  name                = var.fw_name
  location            = var.fw_location
  resource_group_name = var.fw_resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.fw_subnet_id # 1st subnet will create then we will pass the subnet id to this module
    public_ip_address_id = azurerm_public_ip.pip.id 
  }
  tags = var.tags
}

