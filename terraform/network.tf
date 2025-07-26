# Fichero: terraform/network.tf
# Descripción: Define todos los recursos de red para la VM.

# 1. Red Virtual (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-practica2"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 2. Subred
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-practica2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 3. Dirección IP Pública
resource "azurerm_public_ip" "pip" {
  name                = "pip-vm-nginx"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# 4. Interfaz de Red (NIC)
resource "azurerm_network_interface" "nic" {
  name                = "nic-vm-nginx"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

