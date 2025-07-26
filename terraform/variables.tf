# Fichero: terraform/variables.tf
# Descripción: Centraliza todas las variables para que el proyecto sea fácil de configurar.

variable "resource_group_name" {
  description = "Nombre del grupo de recursos para todos los servicios."
  type        = string
  default     = "rg-casopractico2-kevin"
}

variable "location" {
  description = "Región de Azure donde se desplegarán los recursos."
  type        = string
  default     = "Spain Central"
}

variable "acr_name" {
  description = "Nombre único para el Azure Container Registry."
  type        = string
  default     = "acrkevinpracticaunir2" 
}

variable "vm_name" {
  description = "Nombre de la máquina virtual para Podman."
  type        = string
  default     = "vm-podman-nginx"
}

variable "aks_cluster_name" {
  description = "Nombre del clúster de Kubernetes (AKS)."
  type        = string
  default     = "aks-cluster-kevin"
}

variable "admin_username" {
  description = "Nombre de usuario para la VM y AKS."
  type        = string
  default     = "azureuser"
}

variable "admin_ssh_key_public" {
  description = "Clave pública SSH para acceder a la VM y a los nodos de AKS."
  type        = string
  default     = "~/.ssh/id_rsa_azure.pub"
}
