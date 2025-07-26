#!/bin/bash
# Fichero: deploy.sh

set -e

VENV_DIR=".venv"
PLAYBOOK_TO_RUN="ansible/playbook-acr-build-push.yml"

if [ ! -d "$VENV_DIR" ]; then
    echo "ERROR: El entorno virtual no existe. Por favor, ejecuta './setup.sh' primero."
    exit 1
fi

echo "--- 1. Activando el entorno virtual de Python ---"
. ${VENV_DIR}/bin/activate

# --- AÑADIR ESTE BLOQUE DE EXPORTACIÓN CON TUS CREDENCIALES ---
echo "--- 2. Configurando credenciales del Service Principal ---"
export AZURE_CLIENT_ID='el-appId-que-copiaste'
export AZURE_SECRET='el-password-que-copiaste'
export AZURE_TENANT='el-tenant-que-copiaste'
export AZURE_SUBSCRIPTION_ID='tu-subscription-id'
# --- FIN DEL BLOQUE AÑADIDO ---

echo ""
echo "--- 3. Ejecutando el playbook '${PLAYBOOK_TO_RUN}' ---"
ansible-playbook -i ansible/inventory/hosts ${PLAYBOOK_TO_RUN}

echo ""
echo "--- 4. Desactivando el entorno virtual ---"
deactivate

echo ""
echo "🚀 ¡Proceso completado!"
