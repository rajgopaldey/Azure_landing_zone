variable "pip_name"{
type=string
}
variable "fw_name"{
type=string
}
variable "fw_location"{
type=string
}
variable "fw_resource_group_name"{
type=string
}
variable "fw_subnet_id"{
type=string
}

variable "tags" {
  type    = map(string)
  default = {}
}



