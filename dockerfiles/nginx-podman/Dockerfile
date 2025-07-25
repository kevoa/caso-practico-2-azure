# Fichero: dockerfiles/nginx-podman/Dockerfile
# Descripción: Construye una imagen de Nginx personalizada.

# 1. Partimos de la imagen oficial y ligera de Nginx sobre Alpine Linux.
FROM nginx:alpine

# 2. Copiamos nuestro contenido web personalizado al directorio donde Nginx sirve los ficheros.
COPY index.html /usr/share/nginx/html/index.html

# 3. Copiamos los ficheros de seguridad que crearemos más adelante con Ansible.
#    Estos ficheros contendrán el certificado autofirmado y las credenciales de usuario.
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY htpasswd /etc/nginx/htpasswd
COPY server.crt /etc/nginx/server.crt
COPY server.key /etc/nginx/server.key

# 4. Exponemos los puertos 80 (HTTP) y 443 (HTTPS) para que el contenedor pueda recibir tráfico.
EXPOSE 80
EXPOSE 443

