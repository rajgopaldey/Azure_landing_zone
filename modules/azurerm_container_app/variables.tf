variable "container_app_name" {
  type        = string
  description = "Name of the Container App"
}

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

variable "container_registry_server" {
  type        = string
  description = "Server URL of the Azure Container Registry"
}

# 🔑 Manual Testing-er jonno default = "" rakha holo jate pass na korleo error na dei
variable "key_vault_secret_id" {
  type        = string
  default     = ""
  description = "Versionless Key Vault Secret Resource ID or URI (Optional for now)"
}