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
    apt-get install -qy --no-install-recommends \
    git \
    gnupg \
    unzip \
    graphviz \
    mariadb-client \
    lsb-release \
    libcurl4-openssl-dev \
    libssh2-1-dev \
    libldap2-dev \
    libpng-dev \
    libgmp-dev \
    sysbench \
    zlib1g-dev \
    zip && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# PHP Extensions
RUN docker-php-ext-install -j$(nproc) gd mysqli curl gmp sysvmsg sysvsem sysvsem ldap

# Apache conf
RUN sed -ri -e 's!/var/www/html!/data!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!/data!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf && \
    sed -ri -e 's!AllowOverride None!AllowOverride All!g' /etc/apache2/apache2.conf

# PMAControl
RUN git clone https://github.com/PmaControl/PmaControl.git /data && \
    git config core.fileMode false && \
    rm -rf .git && \
    composer install --no-dev && \
    rm -rf configuration && \
    mkdir -p /configuration && \
    ln -s /configuration configuration && \
    if [ ! -f /configuration/db.config.ini.php ]; then \
    cp -a config_sample/*.config.php configuration/ && \
    cp -a config_sample/*.ini.php configuration/ && \
    cp -a config_sample/*.ini configuration/ && \
    sed -ri -e 's!/pmacontrol/!/!' configuration/webroot.config.php; fi &&\
    chown -R www-data:www-data /data /configuration

RUN apt-get remove -yq --purge \
    libcurl4-openssl-dev \
    libssh2-1-dev \
    libldap2-dev \
    libpng-dev \
    libgmp-dev \
    zlib1g-dev \
    binutils \
    cpp \
    g++ \
    make \
    autoconf \
    dpkg-dev \
    gcc && \
    apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./pmacontrol/json/config.json /tmp/config.json
RUN sed -ri -e "s!DB_HOST!${PMACONTROL_DB_HOST}!" /tmp/config.json && \
    sed -ri -e "s!DB_USER!${PMACONTROL_DB_USER}!" /tmp/config.json && \
    sed -ri -e "s!DB_PASSWORD!${PMACONTROL_DB_PASSWORD}!" /tmp/config.json && \
    sed -ri -e "s!DB_BASE!${PMACONTROL_DB_BASE}!" /tmp/config.json
COPY ./pmacontrol/script/init.sh /tmp/init.sh
RUN a2enmod rewrite remoteip

COPY ./pmacontrol/script/init.sh /init.sh
RUN chmod 755 /init.sh

ENTRYPOINT ["/bin/bash", "/init.sh"]
