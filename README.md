# nagios
Repositorio con archivos de instalacion,Scripts y Plugins 

# Guia de instalacion 

## En el host remoto
Esta seccion repasa como instalar nagios en el host que queremos monitorear
# Pasos a seguir para instalar y configurar npre en host remoto

Copiar con winscp los ficheros comprimidos nagios-plugins-2.3.3.tar.gz y nrpe-4.0.3.tar.gz al directio /tmp
<mark>(si esto no se hace el script fallara)</mark>

**Estos ficheros se encuentran en la carpeta plugins**

## Paso 1

**(Con esto vamos a lanzar el script y el &> es para redirigir la salida al fichero npre-nagios-install)**

`./script.sh &> nrpe-nagios-install`


## Paso 2 
**Comprobar la instalacion del agente**
**Confirmar que el puerto que usa nrpe esta escuchando**

`netstat -at | egrep "nrpe|5666"`

**Respuesta esperada en caso de que no obtenga respuesta problema recide en los ssl headers**


`tcp     0      0       *:nrpe      *:*      LISTEN`

**Confirmar que el agente quedo bien instalado**
`/usr/local/nagios/libexec/check_nrpe -H 127.0.0.1`
Respuesta deseada:
`NRPE v4.0.3`

 

## Paso 3
Debemos editar el /usr/local/nagios/etc/nrpe.cfg

`vim /usr/local/nagios/etc/nrpe.cfg`

 **use su editor de confianza**

Buscar la linea de abajo y asegurarse que se vea asi, <mark>(aca estamos permitiendo que el servidor nagios vea el host remoto)</mark>

`allowed_hosts=127.0.0.1,172.18.101.8`

Ademas eliminar el numeral (si lo tiene) al principio de las lineas de abajo
command[check_yum]=/usr/local/nagios/libexec/check_yum
command[check_init_service]=sudo /usr/local/nagios/libexec/check_init_service $ARG1$
command[check_services]=/usr/local/nagios/libexec/check_services -p $ARG1$
command[check_all_procs]=/usr/local/nagios/libexec/custom_check_procs
command[check_procs]=/usr/local/nagios/libexec/check_procs $ARG1$
command[check_open_files]=/usr/local/nagios/libexec/check_open_files.pl $ARG1$
command[check_netstat]=/usr/local/nagios/libexec/check_netstat.pl -p $ARG1$ $ARG2$

## Paso 4
**Reinicie el servicio y habilitelo** 
`systemctl restart nrpe.service`
`systemctl enable nrpe.service`

 

# En el servidor de nagios
**En esta seccion se ve como monitorear el servidor instalado previamente**
## Paso 1 
**Confirmamos que podamos ver el cliente nrpe**
`/usr/local/nagios/libexec/check_nrpe -H (colocar la ip del servidor remoto)`
<mark>La respuesta debe ser esta</mark>
`NRPE v4.0.3`

 

## Paso 2
En `/usr/local/nagios/etc/servers/clientes_activos/catastro/` hay un fichero llamado **template.cfg**

En este archivo se debe editar el nombre y la direccion ip
`cp /usr/local/nagios/etc/servers/clientes_activos/catastro/template.cfg /usr/local/nagios/etc/servers/clientes_activos/catastro/(nombredelhost).cfg`

Para cambiar todo el nombre de una vez en el fichero con vim escribimos esto
`:%s/template.cfg/(nombredelhost).cfg /g`
<mark>Asegurate de cambiar la direccion IP-xxxxxxxxx</mark>

 

##Paso 3
**Asignar el equipo a su host group editando el fichero** 
`/usr/local/nagios/etc/objects/hostgroup.cfg`

 

members                                 Tomcat_WS_Test,Tomcat_Int_Test,Tomcat_Ext_Test

 

Correr este comnado nos permite saber si todo esta correcto antes de reiniciar el servicio nagios
`/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg`

 

**Por ultimo reiniciamos el servicio**
`systemctl restart nagios`