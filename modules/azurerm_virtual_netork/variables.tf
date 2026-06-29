variable "vnt_name" {
  type = string
}
  variable "vnt_location" {
    type = string
  }
  variable "vnt_resource_group_name" {
    type = string
  }
  variable "vnt_address_space" {
    type = list(string)
  }
  variable "vnt_tags" {
    type = map (string)
  }
