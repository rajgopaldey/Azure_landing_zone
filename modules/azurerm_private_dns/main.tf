
resource "azurerm_private_dns_zone" "private_dns" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

#Hub VNet-এর নিজের ভেতরে থাকা রিসোর্সগুলোও 
#(যেমন: Bastion, VM বা অন্য কিছু) যাতে ওই DNS জোনটা ব্যবহার করতে পারে—সেই জন্যই 
#প্রথমে Hub VNet-এর নিজের সাথে এই ডিএনএস জোনের লিঙ্কটা করতে হয়।

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_links" {
  for_each              = var.vnet_to_link # ম্যাপ বা লুপের জন্য
  name                  = "${each.key}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = each.value
  registration_enabled  = true # true দিলে এই VNet-এর VM-গুলো অটোমেটিক DNS রেকর্ড পেয়ে যাবে
}

variable "dns_zone_name" {
  type        = string
}

variable "resource_group_name" {
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vnet_to_link" {
  type = map(string)
}