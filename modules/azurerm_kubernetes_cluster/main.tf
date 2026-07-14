resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
    vnet_subnet_id = var.vnet_subnet_id 
  }

  identity {
    type = "SystemAssigned" #when he use the image fron Acr that movement use it pws not required
  }

  network_profile {
    network_plugin    = "azure" # Azure CNI  will use for pod to pod communication and pod to service communication. It will assign IP address from the subnet to the pods.
    load_balancer_sku = "standard"
  }

  tags = var.tags
}