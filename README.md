# Proyecto de Despliegue Automatizado en Azure (Terraform, Ansible, Docker, Kubernetes)

Este repositorio contiene la infraestructura como código (IaC) y la configuración necesaria para desplegar una solución completa en Microsoft Azure, utilizando Terraform para la infraestructura y Ansible para la gestión de la configuración y el despliegue de aplicaciones Docker y Kubernetes (AKS).

## Descripción General

El objetivo de este proyecto es demostrar la automatización de un entorno de nube desde cero hasta el despliegue de aplicaciones, cubriendo los siguientes aspectos:

- **Infraestructura como Código (IaC):** Despliegue de un Azure Container Registry (ACR), una Máquina Virtual (VM) con Linux y un clúster de Azure Kubernetes Service (AKS) utilizando Terraform.
    
- **Gestión de la Configuración:** Configuración de la VM e instalación de Podman, así como el despliegue de contenedores en la VM y en AKS, todo automatizado con Ansible.
    
- **Contenerización:** Construcción y gestión de imágenes Docker para Nginx y Mongo Express.
    
- **Orquestación:** Despliegue de una aplicación con persistencia (MongoDB + Mongo Express) en AKS.
    
- **Seguridad:** Uso de certificados autofirmados, autenticación básica HTTP, y claves SSH para el acceso seguro.
    

## Requisitos Previos

Antes de comenzar, asegúrate de tener instalados los siguientes requisitos en tu sistema (se recomienda un entorno Linux o WSL):

- **Git:** Para clonar el repositorio.
    
- **Azure CLI:** Para autenticarte en tu cuenta de Azure.
    
- **SSH Client:** Para la gestión de claves SSH.
    

## Estructura del Proyecto

El proyecto está organizado en las siguientes carpetas:

```
.
├── .gitignore                      # Fichero para ignorar archivos no deseados en Git
├── deploy.sh                       # Script para ejecutar playbooks de Ansible
├── setup.sh                        # Script para preparar el entorno Python y Ansible
├── ansible/                        # Contiene los playbooks y el inventario de Ansible
│   ├── inventory/                  # Inventario de hosts para Ansible
│   │   └── hosts
│   ├── files/                      # Archivos estáticos que Ansible copiará
│   ├── playbook-acr-build-push.yml # Playbook para construir y subir imágenes a ACR
│   ├── playbook-aks-deploy.yml     # Playbook para desplegar la aplicación en AKS
│   └── playbook-vm-config.yml      # Playbook para configurar la VM y desplegar Nginx
├── dockerfiles/                    # Contiene los Dockerfiles para las aplicaciones
│   ├── mongo-express-aks/          # Dockerfile para Mongo Express
│   │   └── Dockerfile
│   └── nginx-podman/               # Dockerfile para Nginx
│       ├── Dockerfile
│       ├── index.html
│       └── nginx.conf
├── kubernetes/                     # Manifiestos de Kubernetes para AKS
│   └── mongo-deployment.yml        # Definición de recursos para MongoDB y Mongo Express
└── terraform/                      # Código de Infraestructura como Código con Terraform
    ├── acr.tf                      # Definición de Azure Container Registry
    ├── aks.tf                      # Definición de Azure Kubernetes Service (AKS)
    ├── main.tf                     # Configuración principal de Terraform
    ├── network.tf                  # Definición de recursos de red (VNet, Subnet, IP Pública)
    ├── outputs.tf                  # Salidas de Terraform (ej. IP pública de la VM)
    ├── providers.tf                # Configuración de proveedores de Terraform
    ├── security.tf                 # Definición de Network Security Group (NSG)
    ├── variables.tf                # Variables configurables de Terraform
    └── vm.tf                       # Definición de la Máquina Virtual
```

## Guía de Reproducción Paso a Paso

Sigue estos pasos para desplegar la infraestructura y las aplicaciones en tu suscripción de Azure.

### 1. Clonar el Repositorio

Abre tu terminal (WSL o Linux) y clona el repositorio:

```
git clone https://github.com/tu_usuario/caso-practico-2-azure.git
cd caso-practico-2-azure
```

### 2. Preparar el Entorno

Este script configurará un entorno virtual de Python e instalará todas las dependencias necesarias de Ansible y Azure CLI.

```
sh setup.sh
```

### 3. Activar el Entorno Virtual

Una vez que `setup.sh` haya terminado, activa el entorno virtual de Python. **Deberás hacer esto en cada nueva sesión de terminal.**

```
. .venv/bin/activate
```

### 4. Autenticación en Azure

Asegúrate de estar autenticado en tu cuenta de Azure con la CLI.

```
az login --use-device-code
```

### 5. Generar Claves SSH

Para la máquina virtual de Azure, necesitas una clave SSH de tipo RSA. Si ya tienes una, asegúrate de que sea RSA y apunte a ella en `terraform/variables.tf`. Si no, genera una nueva:

```
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_azure -C "tu_email@example.com"
```

Asegúrate de que la variable `admin_ssh_key_public` en `terraform/variables.tf` apunte a la ruta correcta de tu clave pública (por defecto: `~/.ssh/id_rsa_azure.pub`).

### 6. Despliegue de Infraestructura con Terraform

Navega al directorio de Terraform y despliega la infraestructura base.

```
cd terraform
```

#### a. Inicializar Terraform

```
terraform init
```

#### b. Planificar y Aplicar Terraform

Revisa el plan de cambios y luego aplícalos. Asegúrate de que tu `variables.tf` tenga la `location` configurada a `"Spain Central"` o cualquier otra región permitida por tu suscripción de Azure.

```
terraform plan
terraform apply --auto-approve
```

**Nota:** Si encuentras errores de permisos (`RequestDisallowedByPolicy`) o de nombres (`name needs to be globally unique`), revisa la sección "Consideraciones Adicionales" al final de este README.

### 7. Construcción y Subida de Imágenes Docker a ACR

Regresa al directorio raíz del proyecto y utiliza el script `deploy.sh` para construir y subir las imágenes Docker a tu Azure Container Registry.

```
cd .. # Si estás en la carpeta terraform
sh deploy.sh acr
```

### 8. Despliegue y Configuración con Ansible

Ahora, despliega las aplicaciones en la VM y en AKS utilizando Ansible.

#### a. Desplegar VM y Nginx

Este paso configurará la VM e instalará Nginx con Podman.

```
sh deploy.sh vm
```

#### b. Desplegar AKS y Mongo Express

Este paso desplegará MongoDB y Mongo Express en tu clúster de AKS.

```
sh deploy.sh aks
```

Al finalizar, este script te proporcionará la IP pública para acceder a Mongo Express.

### 9. Acceso a las Aplicaciones

#### a. Acceso al Servidor Web Nginx (en la VM)

Abre tu navegador y navega a la IP pública de tu VM (obtenida de la salida de `terraform apply` o del portal de Azure).

- **Advertencia de Certificado:** Acepta la advertencia de seguridad del navegador (debido al certificado autofirmado).
    
- **Autenticación Básica:** Se te pedirá un usuario y contraseña.
    
    - **Usuario:** `kevin`
        
    - **Contraseña:** `password123`
        
- Una vez autenticado, verás el `index.html` personalizado.
    

#### b. Acceso a Mongo Express (en AKS)

Abre tu navegador y navega a la IP pública proporcionada por el script `sh deploy.sh aks` al finalizar.

- **Autenticación Básica HTTP (Interfaz de Mongo Express):**
    
    - **Usuario:** `admin`
        
    - **Contraseña:** `pass`
        
- Una vez autenticado, accederás al dashboard de Mongo Express, que te permitirá gestionar tu base de datos MongoDB.
    

### 10. Limpieza de Recursos (Opcional pero Recomendado)

Para evitar costes innecesarios, puedes destruir toda la infraestructura creada por Terraform.

```
cd terraform
terraform destroy --auto-approve
```

**Importante:** Este comando eliminará _todos_ los recursos gestionados por Terraform en tu grupo de recursos.

## Consideraciones Adicionales y Resolución de Problemas

- **Errores de Permisos en Azure (`RequestDisallowedByPolicy`):** Si tu suscripción de Azure tiene políticas restrictivas (común en cuentas de estudiante), es posible que necesites ajustar la `location` de los recursos en `terraform/variables.tf` a una región permitida (ej. `"Spain Central"`) y/o añadir `resource_provider_registrations = "none"` en el bloque `provider "azurerm"` de `terraform/providers.tf`.
    
- **Errores de Nombres Únicos:** Recursos como Azure Container Registry (ACR) requieren nombres globalmente únicos. Si te encuentras con un error de nombre ya en uso, simplemente cambia el valor de la variable `acr_name` en `terraform/variables.tf`.
    
- **Problemas de Conectividad SSH:** Si Ansible no puede conectarse a la VM, verifica:
    
    - Que la IP pública de la VM es correcta en `ansible/inventory/hosts`.
        
    - Que la clave SSH privada (`~/.ssh/id_rsa_azure`) tiene los permisos correctos (`chmod 400`).
        
    - Que el puerto 22 está abierto en el NSG de la VM.
        
- **Problemas con `initContainer` de Mongo Express:** Si el pod de Mongo Express se queda en `Init:0/1`, verifica los logs del `initContainer` (`kubectl logs <pod-name> -c wait-for-mongodb`) y del contenedor principal (`kubectl logs <pod-name> -c mongo-express`). Asegúrate de que el servicio de MongoDB se llame `mongo` y que la variable `ME_CONFIG_MONGODB_SERVER` apunte a `mongo`.
    
- **Archivos `.terraform/` y `.terraform.tfstate`:** Estos directorios y archivos **nunca deben subirse a Git**. El `.gitignore` en la raíz del proyecto está configurado para ignorarlos, pero si ya los subiste accidentalmente, necesitarás limpiar tu historial de Git (ver sección "ERROR GRAVE!" en tu documentación interna).
    

¡Disfruta de tu despliegue automatizado!
