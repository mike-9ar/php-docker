#!/bin/bash

MYSQL_USER=${MYSQL_USER:-"root"}
MYSQL_USER_PWD=${MYSQL_USER_PWD:-""}
MYSQL_USER_DB=${MYSQL_USER_DB:-"database"}

echo "Es valor es $MYSQL_USER"

if [ -d /var/lib/mysql/$MYSQL_USER_DB ]; then
    echo '[i] El directorio de base de datos del programa ya existe, omitiendo generación de la DB'
else

    echo "[i] El directorio de base de datos del programa no existe, creando las DBs iniciales"
 
    RET=1
    while [[ RET -ne 0 ]]; do
        echo "=> Esperando inicio del servidor MySql ..."
        sleep 5
        mysql -uroot -e "status" > /dev/null 2>&1
        RET=$?
    done

    # Creamos el usuarios por defecto
    tfile=`mktemp`
    if [ ! -f "$tfile" ]; then
        return 1
    fi
    echo "[i] 2021 MSYS Inc."
    echo ""
    echo "  ___  ___ _______   _______    "
    echo "  |  \/  |/  ___\ \ / /  ___|   "
    echo "  | .  . |\ \`--. \\ V /\\ \`--."
    echo "  | |\/| | \`--. \ \ /  \`--. \ "
    echo "  | |  | |/\__/ / | | /\__/ /   "
    echo "  \_|  |_/\____/  \_/ \____/    "
    echo ""                  
    echo ""
    echo "[i] Creando archivo temporal: $tfile"
    cat <<EOF > $tfile
USE mysql;
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PWD';
GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
>> $tfile

    # run sql in tempfile
    echo "[i] Creando usuario: $tfile"
    mysql -uroot < $tfile
    rm -f $tfile

    echo "=> Volcado inicial de la base de datos ..."
    mysql -uroot < /etc/mysql/init_db.sql

    echo "[i] Finalizado"

fi
RET=1
while [[ RET -ne 0 ]]; do
	echo "=> Esperando servidor MySql ..."
	sleep 5
	mysql -uroot -e "status" > /dev/null 2>&1
	RET=$?
done
echo "=> Actualizando base de datos ..."
mysql -uroot < /etc/mysql/update.sql
echo "[i] Finalizado"
# echo "[i] Iniciando Laravel Service Worker"
# supervisorctl -p dummy -u dummy -c /etc/supervisord.conf start laravel-worker:*
# echo "[i] Hecho"