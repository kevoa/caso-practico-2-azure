#!/bin/bash

# Fichero: setup.sh
# Descripción: Prepara un entorno virtual de Python con todas las dependencias de Ansible.

# --- Salir inmediatamente si un comando falla ---
set -e

VENV_DIR=".venv"

echo "--- 1. Limpiando instalaciones previas para evitar conflictos ---"
sudo pip uninstall -y ansible ansible-core azure-cli podman || true
sudo apt-get remove -y ansible ansible-core || true
sudo apt-get autoremove -y

echo ""
echo "--- 2. Asegurando que las herramientas de entorno virtual de Python están instaladas ---"
sudo apt-get update
sudo apt-get install -y python3-venv

echo ""
echo "--- 3. Creando un entorno virtual de Python limpio en la carpeta '${VENV_DIR}' ---"
rm -rf ${VENV_DIR}
python3 -m venv ${VENV_DIR}

echo ""
echo "--- 4. Activando el entorno virtual e instalando TODO con pip ---"
. ${VENV_DIR}/bin/activate
pip install --upgrade pip

# Instalamos todo el ecosistema, incluyendo las nuevas librerías para Kubernetes
pip install \
    'ansible-core>=2.16' \
    ansible \
    azure-cli \
    podman \
    passlib \
    kubernetes \
    openshift

echo ""
echo "--- 5. Instalando colecciones de Ansible ---"
ansible-galaxy collection install azure.azcollection --force
ansible-galaxy collection install containers.podman --force
ansible-galaxy collection install community.crypto --force
ansible-galaxy collection install community.general --force
# Añadimos la colección para Kubernetes
ansible-galaxy collection install kubernetes.core --force

deactivate

echo ""
echo "✅ ¡Entorno preparado! Ahora usa './deploy.sh [acr|vm|aks]' para ejecutar los playbooks."

