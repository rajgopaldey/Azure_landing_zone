output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id # this output is for the vnet_id
  description = "The ID of the Virtual Network"
}