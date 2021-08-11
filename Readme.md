# Ubuntu LAMP stack para Laravel
## Ubuntu: 20.04 Nginx : nginx/1.18.0 (Ubuntu) PHP : 7.4.3 FMP MySql : 8.0.21
### Volúmenes

* Unidad de persistencia para mysql "/var/lib/mysql",
* Unidad de persistencia para storage "/app/storage" ( ! puede cambiarse mediante ENV )

### Instalación

* Copiar los archivos fuentes del proyecto a la carpeta /www
* Reemplazar el archivo .sql de base de datos ./init_db.sql con el archivo sql de una copia ya instalada y configurada de la aplicación
* Configurar el script DOCKERFILE con los valores de inicialización de la base de datos, nombre de usuario, contraseña, nombre base de datos..
<<<<<<< HEAD
## Configuraciones opcionales

* NGINX: Configurar el archivo docker/nginx/default.conf a las necesidades del server
* PHP: Configurar el archivo docker/php/php.ini
* MYSQL Configurar el archivo docker/mysql/my.cnf

### Compilación

=======
## configuraciones opcionales
* NGINX: Configurar el archivo docker/nginx/default.conf a las necesidades del server
* PHP: Configurar el archivo docker/php/php.ini
* MYSQL Configurar el archivo docker/mysql/my.cnf

### Compilación

>>>>>>> 0f55823a8213cf9db25e00f0ba320b086425864a
Compilar la imagen utilizando el comando docker build . -t imageTag:latest
Ejecutar con el comando docker run 8080:80 imageTag:latest