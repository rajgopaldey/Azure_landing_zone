resource "azurerm_static_web_app" "frontend" {
  name                = var.stb_name
  resource_group_name = var.resource_group_name
  location            = var.stb_location
  sku_tier            = var.sku_tier   # sku-Stock-Keeping Unit
  sku_size            = var.sku_size
}


