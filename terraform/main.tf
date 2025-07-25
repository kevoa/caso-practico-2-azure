# Fichero: terraform/main.tf
# Descripción: Crea el grupo de recursos, que es el contenedor para todo lo demás.

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

