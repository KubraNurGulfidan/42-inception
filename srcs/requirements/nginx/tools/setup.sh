#!/bin/bash

set -e

if [ ! -f "/etc/nginx/ssl/nginx.crt" ]; then
    echo "Generating SSL certificate..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=TR/ST=Istanbul/L=Istanbul/O=42/OU=42/CN=${DOMAIN_NAME}"
    echo "SSL certificate generated!"
fi

sed -i "s/DOMAIN_NAME/${DOMAIN_NAME}/g" /etc/nginx/nginx.conf

echo "Starting Nginx..."
exec nginx -g "daemon off;"