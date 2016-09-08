#!/usr/bin/env bash

sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/cli/php.ini 
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/fpm/php.ini 
sed -i "s/memory_limit = 128M/memory_limit = 256M /g" /etc/php/7.0/fpm/php.ini 

mkdir -p /home/vagrant/code/public
chown vagrant:vagrant -R /home/vagrant/code

mkdir -p /etc/nginx/ssl
openssl genrsa -out "/etc/nginx/ssl/phalcon.key" 1024 2>/dev/null
openssl req -new -key /etc/nginx/ssl/phalcon.key -out /etc/nginx/ssl/phalcon.csr -subj "/CN=phalcon/O=Vagrant/C=UK" 2>/dev/null
openssl x509 -req -days 3650 -in /etc/nginx/ssl/phalcon.csr -signkey /etc/nginx/ssl/phalcon.key -out /etc/nginx/ssl/phalcon.crt 2>/dev/null

cat <<nginx_default > /etc/nginx/sites-available/default
server {
    listen 80;
    listen 443 ssl;
    server_name phalcon;
    root "/home/vagrant/code/public";

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/phalcon-error.log error;

    sendfile off;

    client_max_body_size 100m;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }

    location ~ /\.ht {
        deny all;
    }

    ssl_certificate /etc/nginx/ssl/phalcon.crt;
    ssl_certificate_key /etc/nginx/ssl/phalcon.key;
}
nginx_default
rm -f /etc/nginx/sites-enabled/default
ln -fs "/etc/nginx/sites-available/default" "/etc/nginx/sites-enabled/default"
service nginx restart
service php7.0-fpm restart
