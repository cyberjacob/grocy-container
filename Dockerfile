FROM php:7.3-apache

RUN apt-get update && apt-get install -y \
    libzip-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
      
RUN docker-php-ext-install \
    php7-ctype \
    php7-fpm \
    php7-exif \
    php7-fileinfo \
    php7-gd \
    php7-iconv \
    php7-json \
    php7-ldap \
    php7-pdo_sqlite \
    php7-simplexml \
    php7-tokenizer

RUN mkdir -p /grocy && \
        curl -o /grocy/grocy.zip -L "https://releases.grocy.info/latest"

WORKDIR /grocy
RUN unzip grocy.zip

RUN mkdir -p /config && \
    cp /grocy/config-dist.php config.php && \
    ln -s /config/config.php /grocy/config.php

# RUN chmod 777 -R .

RUN sed -ri -e 's!/var/www/html!/grocy/public!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!/grocy/public!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf && \
    sed -ri -e 's!Listen 80!Listen 29397!g' /etc/apache2/ports.conf /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!80!29397!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!AllowOverride None!AllowOverride All!g' /etc/apache2/apache2.conf && \
    a2enmod rewrite && a2enmod negotiation
