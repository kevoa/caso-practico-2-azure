# Fichero: terraform/aks.tf
# Descripción: Define el clúster de Azure Kubernetes Service (AKS) y su integración con ACR.

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.aks_cluster_name}-dns"

  default_node_pool {
    name       = "default"
    node_count = 1 # Requerido por la práctica: un único worker.
    vm_size    = "Standard_B2s" # Un tamaño de VM pequeño para controlar costes.
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "practica2"
    owner       = "kevin"
  }
}

# Integración entre AKS y ACR
# Esta asignación de rol le da al clúster de AKS permiso para "pull" (descargar)
# imágenes desde nuestro Azure Container Registry privado.
resource "azurerm_role_assignment" "aks_acr_integration" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

