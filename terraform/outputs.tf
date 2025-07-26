# Fichero: terraform/outputs.tf
# Descripción: Define los valores de salida que queremos ver después de un 'apply'.

output "vm_public_ip" {
  description = "La dirección IP pública de la máquina virtual Nginx."
  value       = azurerm_public_ip.pip.ip_address
}

