#!/bin/bash
###########################################
#                                         #
#     Configuración Nube de Docker        #
#                                         #
###########################################

######## Dentro del servidor esclavo ########

# Permitimos el trafico por el puerto 2376
firewall-cmd --permanent --add-port=2376/tcp
firewall-cmd --reload

# Exponemos el Api de Docker
## Agregamos la siguiente entrada al archivo /etc/docker/daemon.json
"hosts":["unix:///var/run/docker.sock","tcp://0.0.0.0:2376"]

# Reiniciamos Docker para hacer efectivos los cambios
systemctl restart docker

# Verificamos que el puerto este escuchando
netstat -pantu | grep 2376

# Descargar Imagen en el builder
docker pull docker.io/kevopsoficial/jenkins-slave

#### Dentro de Jenkins ######
# Instalar plugin de Docker.

# Docker Host URI: tcp://10.142.0.2:2376 # Ip del servidor Builder
## Test de conexion ---> Version = 1.13.1, API Version = 1.26
# Container Cap: 1
# Docker Agent templates
## Labels: docker-esclavos
## Enabled: check
## Name: docker-esclavo-contenedor
## Docker Image: docker.io/kevopsoficial/jenkins-slave
## Connect method: with JLNP
### User: root
### Establecer un túnel a traves de: 10.128.0.9:50000 # Ip del jablab/puerto_tunel

#######################################

# Crear nueva tarea
# Restringir dónde se puede ejecutar este proyecto.: docker-esclavos