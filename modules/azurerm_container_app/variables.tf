variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region for deployment"
}

variable "infrastructure_subnet_id" {
  type        = string
  description = "Subnet ID integrated for Container Apps Environment network routing"
}

variable "container_registry_id" {
  type        = string
  description = "Resource ID of the Azure Container Registry"
}

variable "container_image_name" {
  type        = string
  default     = "mcr.microsoft.com/azuredocs/aci-helloworld:latest" # Default initialization image
}