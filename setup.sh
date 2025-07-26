#!/bin/bash
# Fichero: setup.sh (versión de MÁXIMA SIMPLICIDAD)
# Descripción: Crea un entorno limpio e instala solo lo esencial, confiando en sus dependencias.

set -e
VENV_DIR=".venv"

echo "--- 1. Creando entorno virtual limpio en ${VENV_DIR} ---"
rm -rf ${VENV_DIR}
python3 -m venv ${VENV_DIR}

echo ""
echo "--- 2. Activando entorno e instalando dependencias ---"
. ${VENV_DIR}/bin/activate
pip install --upgrade pip

echo ""
echo "--- 3. Instalando solo lo esencial: Ansible, Azure-CLI y Podman ---"
pip install \
    'ansible-core>=2.16' \
    'azure-cli' \
    'podman' \
    'passlib'

echo ""
echo "--- 4. Instalando colecciones de Ansible ---"
ansible-galaxy collection install azure.azcollection:2.2.0 --force # Usamos una versión estable
ansible-galaxy collection install containers.podman --force
ansible-galaxy collection install community.general --force
ansible-galaxy collection install community.crypto --force

deactivate
echo ""
echo "✅ ¡Entorno preparado! ✅"
