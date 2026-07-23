output "key_vault_id" {
  description = "Key Vault Resource ID"
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "Key Vault Name"
  value       = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = azurerm_key_vault.this.vault_uri
}
output "secret_versionless_id" {
  value       = azurerm_key_vault_secret.db_secret.versionless_id
  description = "The Versionless ID of the Key Vault Secret"
}