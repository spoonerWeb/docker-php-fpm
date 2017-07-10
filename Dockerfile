FROM php:7.0-fpm-alpine
MAINTAINER Sascha Marcel Schmidt <docker@saschaschmidt.net>

RUN apk update && \
    apk add \
        bash \
        imagemagick \
        imagemagick-dev \
        openssh-client \
        sudo \
        git \
        libmemcached-dev \
        openssl \
        openssl-dev \
        libpng-dev \
        jpeg-dev \
        re2c \
        freetype-dev \
        libmcrypt-dev \
        libxml2-dev \
        cyrus-sasl-dev \
        libmemcached-dev \
        libtool


RUN cd /tmp/ && \
    mkdir -p /usr/src/php/ext && \
    curl -O http://pecl.php.net/get/xdebug-2.5.0.tgz && \
    tar zxvf xdebug-2.5.0.tgz && \
    mv xdebug-2.5.0 /usr/src/php/ext/xdebug && \
    curl -O https://pecl.php.net/get/mongodb-1.2.2.tgz && \
    tar zxvf mongodb-1.2.2.tgz && \
    mv mongodb-1.2.2 /usr/src/php/ext/mongodb && \
    curl -O https://pecl.php.net/get/imagick-3.4.3RC1.tgz && \
    tar zxvf imagick-3.4.3RC1.tgz && \
    mv imagick-3.4.3RC1 /usr/src/php/ext/imagick && \
    curl -LO https://github.com/php-memcached-dev/php-memcached/archive/v3.0.1.tar.gz && \
    tar zxvf v3.0.1.tar.gz && \
    mv php-memcached-3.0.1 /usr/src/php/ext/memcached && \
    curl -O https://pecl.php.net/get/redis-3.1.1.tgz && \
    tar zxvf redis-3.1.1.tgz && \
    mv redis-3.1.1 /usr/src/php/ext/redis && \
    echo 'xdebug' >> /usr/src/php-available-exts && \
    echo 'mongodb' >> /usr/src/php-available-exts && \
    echo 'imagick' >> /usr/src/php-available-exts && \
    echo 'memcached' >> /usr/src/php-available-exts && \
    echo 'redis' >> /usr/src/php-available-exts && \
    cd / && \
    rm -rf /tmp/*

RUN cd /usr/src/ && tar -xf php.tar.xz && cp -rf php-${PHP_VERSION}/* php && cd /var/www/html && \
    docker-php-ext-configure gd --with-jpeg-dir --with-png-dir --with-freetype-dir && \
    docker-php-ext-install \
    gd \
    imagick \
    xdebug \
    soap \
    iconv \
    mcrypt \
    mbstring \
    pdo_mysql \
    mysqli \
    zip \
    bcmath \
    opcache \
    mongodb \
    memcached \
    redis \
    ldap \
    pcntl && \
    rm -rf /usr/src/php*

RUN addgroup -g 666 superuser && \
    echo '%superuser        ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers

CMD ["php-fpm"]

ENTRYPOINT ["bash", "-i", "/usr/local/bin/entrypoint.sh"]
COPY src/ /usr/local/
RUN chmod +x /usr/local/bin/entrypoint.sh
