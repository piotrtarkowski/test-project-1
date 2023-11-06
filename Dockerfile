FROM php:8.2-apache
RUN apt-get update && apt-get install -y libzip-dev libpng-dev zlib1g-dev libicu-dev libpq-dev
RUN docker-php-ext-configure intl
RUN docker-php-ext-install pdo_mysql pdo_pgsql mysqli intl opcache zip gd
RUN docker-php-ext-enable pdo_mysql pdo_pgsql mysqli intl zip opcache gd
RUN a2enmod rewrite ssl http2 headers

RUN /etc/init.d/apache2 restart

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN echo 'date.timezone = "Europe/Warsaw"' >> /usr/local/etc/php/conf.d/docker-php-tzone.ini

RUN pecl install xdebug && docker-php-ext-enable xdebug \
    && echo "zend_extension=xdebug.so" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host = 127.0.0.1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.discover_client_host = true" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

WORKDIR /var/www/html
