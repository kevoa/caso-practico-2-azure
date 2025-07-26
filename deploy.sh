#!/bin/bash

# Fichero: deploy.sh
# Descripción: Orquestador principal para ejecutar los playbooks de Ansible.

# --- Salir inmediatamente si un comando falla ---
set -e

# --- 1. Validar que se ha pasado un argumento ---
if [ -z "$1" ]; then
    echo "ERROR: Debes especificar qué parte desplegar."
    echo "Uso: $0 [acr|vm|aks]"
    exit 1
fi

VENV_DIR=".venv"
TARGET=$1

# --- 2. Comprobar si el entorno virtual existe ---
if [ ! -d "$VENV_DIR" ]; then
    echo "ERROR: El entorno virtual no existe. Por favor, ejecuta './setup.sh' primero."
    exit 1
fi

echo "--- 3. Activando el entorno virtual de Python ---"
# Usamos '.' en lugar de 'source' para máxima compatibilidad
. ${VENV_DIR}/bin/activate

echo ""
echo "--- 4. Autenticándose en Azure (si es necesario)... ---"
# Verificamos si ya hay una sesión activa, si no, pedimos login.
# Redirigimos la salida a /dev/null para que no muestre nada si tiene éxito.
az account show > /dev/null 2>&1 || az login --use-device-code

echo ""
echo "--- 5. Ejecutando el playbook para '${TARGET}' ---"

# --- Decidir qué playbook ejecutar basándose en el argumento ---
case "$TARGET" in
    acr)
        ansible-playbook -i ansible/inventory/hosts ansible/playbook-acr-build-push.yml
        ;;
    vm)
        ansible-playbook -i ansible/inventory/hosts ansible/playbook-vm-config.yml
        ;;
    aks)
        ansible-playbook -i ansible/inventory/hosts ansible/playbook-aks-deploy.yml
        ;;
    *)
        echo "ERROR: Argumento no válido. Usa 'acr', 'vm' o 'aks'."
        deactivate
        exit 1
        ;;
esac

echo ""
echo "--- 6. Desactivando el entorno virtual ---"
deactivate

echo ""
echo "🚀 ¡Proceso '${TARGET}' completado!"
