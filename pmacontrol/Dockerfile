FROM php:8.3-apache

ENV COMPOSER_ALLOW_SUPERUSER=1

EXPOSE 80
WORKDIR /data

ENV PMACONTROL_DB_HOST mariadb
ENV PMACONTROL_DB_USER root
ENV PMACONTROL_DB_PASSWORD password
ENV PMACONTROL_DB_BASE pmacontrol

# git, unzip & zip are for composer
RUN apt-get update -qq && \
    apt-get install -qy \
    git \
    gnupg \
    unzip \
    graphviz \
    lsb-release \
    libcurl4-openssl-dev \
    libssh2-1-dev \
    libpng-dev \
    libgmp-dev \
    zlib1g-dev \
    zip && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# PHP Extensions
RUN docker-php-ext-install -j$(nproc) gd mysqli curl gmp
RUN pecl install ssh2 \
	&& docker-php-ext-enable ssh2

# Apache conf
RUN sed -ri -e 's!/var/www/html!/data!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!/data!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN sed -ri -e 's!AllowOverride None!AllowOverride All!g' /etc/apache2/apache2.conf

# PMAControl
RUN git clone https://github.com/PmaControl/PmaControl.git /data && \
    git config core.fileMode false && \
    composer install
RUN cp -a config_sample/*.config.php configuration/ && \
    cp -a config_sample/*.ini.php configuration/ && \
    cp -a config_sample/*.ini configuration/
RUN sed -ri -e 's!/pmacontrol/!/!' configuration/webroot.config.php
RUN sed -ri -e "s!hostname=127.0.0.1!hostname=${PMACONTROL_DB_HOST}!" configuration/db.config.ini.php && \
    sed -ri -e "s!user=root!user=${PMACONTROL_DB_USER}!" configuration/db.config.ini.php && \
    sed -ri -e "s!password='password'!password=${PMACONTROL_DB_PASSWORD}!" configuration/db.config.ini.php && \
    sed -ri -e "s!database=pmacontrol!database=${PMACONTROL_DB_BASE}!" configuration/db.config.ini.php
RUN /usr/local/bin/php App/Webroot/index.php control createTsTable
RUN /usr/local/bin/php App/Webroot/index.php agent updateServerList
RUN /usr/local/bin/php App/Webroot/index.php administration generate_model
RUN /usr/local/bin/php App/Webroot/index.php administration admin_table

RUN a2enmod rewrite remoteip
