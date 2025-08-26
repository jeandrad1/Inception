#!/bin/bash

# Wait for the database to be ready
# Simple loop that tries to connect to the DB.
# In a real-world scenario, you might use a more robust tool like docker-compose-wait.
until mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    echo "Waiting for database..."
    sleep 2
done

# Set the working directory
cd /var/www/html

# Check if WordPress is already configured. If wp-config.php exists, we assume it is.
if [ -f wp-config.php ]; then
    echo "WordPress is already configured."
else
    echo "Configuring WordPress..."

    # Download wp-cli
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp

    # Create wp-config.php using environment variables
    wp config create --allow-root \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --path='/var/www/html'

    # Install WordPress and create the admin user
    # You should add WORDPRESS_ADMIN_USER, WORDPRESS_ADMIN_PASSWORD, and WORDPRESS_ADMIN_EMAIL to your .env file
    wp core install --allow-root \
        --url="https://jeandrad.42.fr" \
        --title="Inception" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --path='/var/www/html'

    echo "WordPress configured successfully."
fi

# Start the PHP-FPM service in the foreground
echo "Starting PHP-FPM..."
php-fpm
