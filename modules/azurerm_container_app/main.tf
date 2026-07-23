#Container App Environment is a Secure Boundary / Virtual Cluster.
resource "azurerm_container_app_environment" "aca_env" {
  name                           = "dev-aca-environment"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  infrastructure_subnet_id       = var.infrastructure_subnet_id 
  #its mean don't come in publick network use vnet's backend-subnet

  internal_load_balancer_enabled = true #ilb
#if we enable ilb into the container app environment azure distrubuted the trafic with multiple container app
}

#Container App 
resource "azurerm_container_app" "app_container" {
  name                         = "info-app-service"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

#if application/container app want to access-Azure Key Vault, Database, ba Container Registry no need any psw
  identity {
    type = "SystemAssigned" #by this block create manageidentity
  }

  #Key Vault Secret Block (Secret fetch korar jonno)
  secret {
    name                = "db-secret"
    key_vault_secret_id = var.key_vault_secret_id # Key Vault Secret Versionless URI
    identity            = "SystemAssigned"
  }

  # 📦 ACR Registry Authentication (SystemAssigned Managed Identity via ACR Pull)
  registry {
    server   = var.container_registry_server # e.g. myacr.azurecr.io
    identity = "SystemAssigned"
  }

  ingress {
    allow_insecure_connections = false #Only https request allow http not alowed
    external_enabled           = true  #All srevice request from (SWA/APIM) should be route into the internal vnet
    target_port                = 5000 
    transport                  = "auto"
   #when container image new version will came by application pipeline all trafic will shifted in new Version-v2
    traffic_weight {
      percentage      = 100 #all trafic
      latest_revision = true #latest version v2
    }
  }

  template {
    container {
      name   = "todo-backend"
      image  = var.container_image_name
      cpu    = "0.25"
      memory = "0.5Gi"

      # 🔑 Environment variable mapping
      env {
        name        = "DB_PASSWORD"
        secret_name = "db-secret"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].container[0].image # CI/CD pipe push matrix dynamic deploy runtime image change overwrite validation handling parameters overwrite bypass text execute
    ]
  }
}