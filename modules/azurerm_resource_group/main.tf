resource "azurerm_resource_group" "main" { 
    name = var.rg_name
    location = var.rg_location
    tags     = var.rg_tags
}

