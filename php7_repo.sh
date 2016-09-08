#!/bin/bash

sed -i "s/main$/main contrib/g" /etc/apt/sources.list

cat <<php_7 > /etc/apt/sources.list.d/dotdeb.list
deb http://packages.dotdeb.org jessie all
deb-src http://packages.dotdeb.org jessie all
php_7

wget -qO - http://www.dotdeb.org/dotdeb.gpg | sudo apt-key add -

apt update