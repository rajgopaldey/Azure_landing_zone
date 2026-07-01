resource "azurerm_publick_ip" "pip" {
    name= var.pip_name
    location = var.pip_location
    pip_resource_group_name = var.pip_resource_group_name   
    allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

variable "pip_name"{
type=string
}
variable "var.pip_location"{
type=string
}
variable "var.pip_resource_group_name"{
type=string
}

