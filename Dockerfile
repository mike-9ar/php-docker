FROM ubuntu:20.04

# creación de usuario de la base de datos
ENV MYSQL_USER user
ENV MYSQL_USER_PWD 1234 
ENV MYSQL_USER_DB database

# ruta al storage de laravel
ENV STORAGE_PATH /app/storage

ENV ITDEVGROUP_TIME_ZONE America/Argentina/Buenos_Aires

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
    nginx \
    mysql-server \
    php7.4 \
    supervisor \
	# redis \
	# cron \
	##  php7.4 extensiones
	php7.4-bcmath \
	php-ctype \
	php7.4-ldap \
	php7.4-json \
	php7.4-mbstring \
	php-xml \
	php7.4-zip  \
	openssl \
	php-tokenizer \
	php7.4-pdo \
	php7.4-pdo-mysql \
	php7.4-mysql \
	php7.4-cli \
	php7.4-gd  \
	php7.4-opcache \
	php7.4-common \
	php7.4-intl \
	php7.4-xsl \
	php7.4-imap \	
	php7.4-curl \
    php7.4-zip  \
    php7.4-fpm \
	php-redis\
	php-memcached \
	# utilidades
	pkg-config \
	ssmtp \
	nano \
	composer \
	&& rm -rf /var/lib/apt/lists/*


# Timezone por defecto
RUN echo "date.timezone=$ITDEVGROUP_TIME_ZONE" > /etc/php/7.4/cli/conf.d/timezone.ini

# msyql configuración
COPY /docker/mysql/my.cnf   /etc/mysql/my.cnf
COPY /init_db.sql /etc/mysql/init_db.sql
COPY /update.sql /etc/mysql/update.sql
COPY /docker/mysql/initdb.sh   /etc/mysql/initdb.sh
COPY /docker/mysql/createdb.sh   /etc/mysql/createdb.sh

RUN chmod 0444 /etc/mysql/my.cnf
RUN chmod +x /etc/mysql/initdb.sh

# COPY . /
COPY /docker/nginx/nginx.conf   /docker/nginx/nginx.conf
COPY /docker/nginx/default.conf /docker/nginx/default.conf
COPY /docker/nginx/server.conf /docker/nginx/server.conf
COPY /docker/php/php.ini   /docker/php/php.ini
COPY /docker/php/php.ini   /etc/php/7.4/cli/php.ini
COPY /docker/php/www.conf   /docker/php/www.conf
COPY /docker/supervisor/supervisor.conf   /docker/supervisor/supervisor.conf
COPY /docker/cron/laravel /etc/cron.d/laravel

# creamos y copiamos el resto de la configuración
RUN mkdir -p /var/tmp/nginx \
    && mkdir app \
    && mkdir /etc/nginx/conf.d/server \
    && mkdir -p /var/log/supervisor \
    && mkdir -p /etc/nginx/conf.d \
    && mkdir -p /etc/php7/php-fpm.d \
	&& cp -rf /docker/nginx/server.conf  /etc/nginx/conf.d/server \
    && cp -rf /docker/nginx/nginx.conf  /etc/nginx/nginx.conf \
    && cp -rf /docker/nginx/default.conf                /etc/nginx/conf.d/default.conf \
    && cp -rf /docker/php/php.ini                       /etc/php7/php.ini \
    && cp -rf /docker/php/www.conf                      /etc/php7/php-fpm.d/www.conf \
    && cp -rf /docker/supervisor/supervisor.conf        /etc/supervisord.conf

# MSYS 2020
ADD --chown=www-data:www-data www /app/

COPY www /app/
RUN chmod a+rwx -R $STORAGE_PATH

RUN chown root:root /etc/cron.d/* \
	&& chmod 0644 /etc/cron.d/*
	
WORKDIR /app

# opcional
RUN composer install

# portal
EXPOSE 80

# persistencia
VOLUME ["/var/lib/mysql", "${STORAGE_PATH}"]

CMD [ "/etc/mysql/createdb.sh" ]