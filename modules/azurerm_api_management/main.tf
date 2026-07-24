# We need to apiresource create
resource "azurerm_api_management" "this" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name   #azure portal a notification jono
  publisher_email     = var.publisher_email  #azure portal a notification jono
  sku_name            = var.sku_name

  
  #virtual_network_type = "Internal"       #connect to apim with vnet its publick ip will off
  # virtual_network_configuration {
  #   subnet_id = var.apim_subnet_id   #apim ar jono special subnet
  # }

identity {           #Identity & Governance Settings
    type = "SystemAssigned"
  }

  #tfsec:ignore:azure-api-management-min-tls-12
  min_api_version = "2021-08-01"
}

#After api resource create how trafic will routing ########
resource "azurerm_api_management_api" "backend_api" {
  name                = "backend-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.this.name
  revision            = "1"
  display_name        = "Backend Container App API"
  path                = "api/v1"
  protocols           = ["https"]
}

#api container app songa link
resource "azurerm_api_management_backend" "container_app_backend" {
  name                = "container-app-backend"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.this.name
  protocol            = "http"
  url                 = "https://${var.container_app_fqdn}"
}



# Ebar proshno holo: Public APIM ki VNet-er bhetor thaka Container App-ke access 
# korte parbe?
# Ha, parbe, tabe ekta শর্ত (Condition) ache:

# Scenario A: Container App-er Ingress "External" (Publicly Accessible) kora thakle:
# APIM public internet hoye Container App-er FQDN (https://<app>.azurecontainerapps.io)-e request pathate parbe. Processing-er jonno traffic public internet hoye Container App-e pouchobe.

# Scenario B: Container App-er Ingress "Internal" (Shudhu VNet-er bhetore) kora thakle:
# Public APIM direct Container App-e request pathate parbe na, karon Container App-er public exposure-i bondho. Tokhon APIM-ke VNet-e rakha (virtual_network_type = "Internal") ba Private Endpoint/Private DNS use kora mandatory
