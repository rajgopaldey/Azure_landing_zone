output "acr_id" {
  # ⚠️ Jodi main.tf-e resource name "acr" er bodole "main" thake, 
  # tobe "azurerm_container_registry.main.id" likhbe.
  value       = azurerm_container_registry.acr.id
  description = "The ID of the Azure Container Registry"
}