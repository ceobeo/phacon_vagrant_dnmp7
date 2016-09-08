#!/bin/bash

set -e 

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export DEBIAN_FRONTEND=noninteractive

apt install -y --allow-unauthenticated \
    nginx \
    php7.0-fpm \
    php7.0-mysql \
 	php7.0-curl \
	php7.0-gd \
	php7.0-intl \
    php7.0-phalcon \
    mysql-server-5.5 \
    zip \
    mc
