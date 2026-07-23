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

# 🚀 NEW: Added for Container Registry Login Server (e.g., myacr.azurecr.io)
variable "container_registry_server" {
  type        = string
  description = "Server URL of the Azure Container Registry"
}

# 🔑 NEW: Added for Key Vault Secret URI mapping
variable "key_vault_secret_id" {
  type        = string
  description = "Versionless Key Vault Secret Resource ID or URI"
}