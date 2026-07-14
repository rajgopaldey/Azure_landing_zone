output "firewall_private_ip" {
  description = "The Private IP address of the Azure Firewall"
  value       = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}
#He route requets fron spoke to huv firewall privete ip address and then it will go to 
#internet or other destination