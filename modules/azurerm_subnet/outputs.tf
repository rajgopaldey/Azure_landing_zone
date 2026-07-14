output "subnet_ids" {
  value = { for k, v in azurerm_subnet.main : k => v.id } 
}

#for multiple subnets we use for_each loop and create a map of subnet names and their ids.
# The output will be a map of subnet names and their corresponding ids.