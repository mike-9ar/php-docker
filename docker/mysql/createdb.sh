#!/bin/bash

# directorio donde se almacena el socket mysql
if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
    echo '[i] El directorio MySQL ya existe, omitiendo generación de la DB'
else

    echo "[i] El directorio MySQL no existe, creando las DBs iniciales"

    mysqld --initialize-insecure --datadir=/var/lib/mysql --user=mysql

fi

/usr/bin/supervisord -c /etc/supervisord.conf