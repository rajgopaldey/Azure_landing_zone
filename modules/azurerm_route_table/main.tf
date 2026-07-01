resource "azurerm_route_table" "rt" {
  name                          = var.rt_name
  location                      = var.rt_location
  resource_group_name           = var.rt_resource_group_name
  disable_bgp_route_propagation = true #unable to acces from officr router if false

  # ডিফল্ট রুট: সব ট্রাফিক (0.0.0.0/0) ফায়ারওয়ালের প্রাইভেট আইপিতে পাঠাবে
  route {
    name                   = "route-to-hub-fw"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }

  tags = var.tags
}

