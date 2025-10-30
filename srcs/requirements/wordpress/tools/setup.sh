#!/bin/bash

set -e

DB_PASS=$(cat /run/secrets/db_password)
CREDENTIALS=$(cat /run/secrets/credentials)

WP_ADMIN_PASSWORD=$(echo "$CREDENTIALS" | grep WP_ADMIN_PASSWORD | cut -d'=' -f2)
WP_USER_PASSWORD=$(echo "$CREDENTIALS" | grep WP_USER_PASSWORD | cut -d'=' -f2)
ADMIN_USER_FROM_SECRET=$(echo "$CREDENTIALS" | grep WP_ADMIN_USER | cut -d'=' -f2 || true)

if [ -z "${WP_ADMIN_USER:-}" ] && [ -n "$ADMIN_USER_FROM_SECRET" ]; then
    WP_ADMIN_USER="$ADMIN_USER_FROM_SECRET"
fi

echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -h mariadb -u ${MYSQL_USER} -p${DB_PASS} --silent; do
    echo "Waiting for database connection..."
    sleep 2
done

echo "MariaDB is ready!"

if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Installing WordPress..."
    
    wp core download --allow-root
    
    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${DB_PASS} \
        --dbhost=mariadb:3306 \
        --allow-root
    
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root
    
    wp user create \
        ${WP_USER} \
        ${WP_USER_EMAIL} \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root
    
    echo "WordPress installed successfully!"
else
    echo "WordPress already installed."
fi

if ! wp user get "${WP_ADMIN_USER}" --field=ID --allow-root >/dev/null 2>&1; then
    echo "Admin user not found. Creating administrator '${WP_ADMIN_USER}'..."
    wp user create \
        "${WP_ADMIN_USER}" \
        "${WP_ADMIN_EMAIL}" \
        --role=administrator \
        --user_pass="${WP_ADMIN_PASSWORD}" \
        --allow-root
fi

chown -R www-data:www-data /var/www/html

exec php-fpm7.4 -F