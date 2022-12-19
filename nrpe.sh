#!/bin/bash
#Antes de correr el script asegurate que el archivo nagios-plugins-2.3.3.tar.gz y nrpe-4.0.3.tar.gz esten en /tmp, si no esto va a fallar
#Instala herramientas de compilacion
apt install gcc make libssl-dev -y
#Cambia al directorio 
cd /tmp
#Descomprime el archivo Nagios-plugins
tar xzf nagios-plugins-2.3.3.tar.gz
#Cambia al directorio de nagios-plugins
cd nagios-plugins-2.3.3
#Configura los paquetes que se van a instalar
./configure
#Compila los paquetes
make
#Instala los paquetes compilados
make install
#Agrega el usuario Nagios
useradd nagios
#Agrega el grupo Nagios
groupadd nagios
#Agrega el usuario nagios al grupo nagios
usermod -a -G nagios nagios
#Ahora Nagios es el dueño del directorio
chown nagios.nagios /usr/local/nagios
#Aca hacemos los mismo pero de manera recursiva en el directorio /usr/local/nagios/libexec
chown -R nagios.nagios /usr/local/nagios/libexec
#Instalamos Xinetd
apt install xinetd -y
#Volvemos a /tmp
cd ..
#Descomprimimos Nrpe cliente
tar xzf nrpe-4.0.3.tar.gz
#Cambiamos de directorio
cd nrpe-4.0.3
#Aca configuramos, compilamos e instalamos todas la funciones del cliente NRPE
./configure
make all
make install-groups-users
make install
make install-config
make install-inetd
make install-init
#Reiniciamos y habilitamos el servicio xinetd
service xinetd restart
systemctl reload xinetd
systemctl enable nrpe && systemctl start nrpe
#abrir puerto 5666 en el servidor 
firewall-cmd --add-port 5666/tcp