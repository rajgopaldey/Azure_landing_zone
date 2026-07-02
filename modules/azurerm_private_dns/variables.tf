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