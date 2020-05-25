#!/bin/bash
#########################################
#                                       #
#            Runit Jenkins              #
#                                       #
#########################################

# Permitimos el trafico por los puertos 50000
firewall-cmd --permanent --add-port=50000/tcp
firewall-cmd --reload

# En caso de hacer un despliegue de manera local permitir el trafico al puerto que hara match con el del contenedor
# En este ejemplo suponemos que será el puerto 8080

JENKINS_HOST_PORT=8080

# Permitimos el trafico por los puertos 8080
firewall-cmd --permanent --add-port=$JENKINS_HOST_PORT/tcp
firewall-cmd --reload

# Despliegue del contenedor
JENKINS_CONTAINER=jenkins-server
mkdir -p /var/containers/$JENKINS_CONTAINER/var/jenkins_home
chown 1000:1000 -R /var/containers/$JENKINS_CONTAINER

docker run -itd --name $JENKINS_CONTAINER \
    --restart always \
    -p $JENKINS_HOST_PORT:8080 \
    -p 50000:50000 \
    -v /etc/localtime:/etc/localtime:ro \
    -v /usr/share/zoneinfo:/usr/share/zoneinfo:ro \
    -v /var/containers/$JENKINS_CONTAINER/var/jenkins_home:/var/jenkins_home:z \
    -e TZ=America/Mexico_City \
    jenkins/jenkins:lts

# Revisar http://localhost:$JENKINS_HOST_PORT