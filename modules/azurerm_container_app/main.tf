# 1. Container Apps Managed Environment (Private Mode Enabled via Subnet)
resource "azurerm_container_app_environment" "aca_env" {
  name                       = "dev-aca-environment"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  infrastructure_subnet_id   = var.infrastructure_subnet_id
  internal_load_balancer_enabled = true 
}

# 2. Private Backend Microservice Container App Instance
resource "azurerm_container_app" "todo_api" {
  name                         = "add-task-service"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
#if application/container app want to access-Azure Key Vault, Database, ba Container Registry no need any psw
  identity {
    type = "SystemAssigned" 
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
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].container[0].image # CI/CD pipe push matrix dynamic deploy runtime image change overwrite validation handling parameters overwrite bypass text execute
    ]
  }
}