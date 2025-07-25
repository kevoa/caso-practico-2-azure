# Fichero: terraform/acr.tf
# Descripción: Define el recurso Azure Container Registry (ACR).

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    environment = "practica2"
    owner       = "kevin"
  }
}

