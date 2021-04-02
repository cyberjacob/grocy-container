FROM php:7.3-apache

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libldap-dev \
    unzip \
#    libsqlite3-dev \
#    libxml2-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
      
RUN docker-php-ext-install \
#    ctype \
#    fpm \
    exif \
#    fileinfo \
    gd \
#    iconv \
#    json \
    ldap
#    pdo_sqlite \
#    simplexml \
#    tokenizer

RUN mkdir -p /grocy && \
        curl -o /grocy/grocy.zip -L "https://releases.grocy.info/latest"

WORKDIR /grocy
RUN unzip grocy.zip

RUN ln -s /config /grocy/data && \
    cp /grocy/config-dist.php /config/config.php
#    ln -s /config/config.php /grocy/data/config.php
#    ln -s /config/grocy.db /grocy/data/

# RUN chmod 777 -R .

RUN sed -ri -e 's!/var/www/html!/grocy/public!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!/grocy/public!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf && \
    sed -ri -e 's!Listen 80!Listen 29397!g' /etc/apache2/ports.conf /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!80!29397!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!AllowOverride None!AllowOverride All!g' /etc/apache2/apache2.conf && \
    a2enmod rewrite && a2enmod negotiation
