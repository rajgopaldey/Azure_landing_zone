variable "rt_name" {
  type = string
}       
variable "rt_location" {
  type = string
}   
variable "rt_resource_group_name" {
  type = string
}   
variable "firewall_private_ip" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}