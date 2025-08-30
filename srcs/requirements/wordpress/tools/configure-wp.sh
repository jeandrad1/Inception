#!/bin/bash
set -e

# Always copy WordPress files if they don't exist in the target directory.
# This is safer than checking if the directory is empty.
if [ ! -f "/var/www/html/index.php" ]; then
    echo "WordPress not found. Copying files..."
    cp -r /usr/src/wordpress/* /var/www/html/
fi

# Wait for the database port to be open before proceeding.
echo "Waiting for database host '$WORDPRESS_DB_HOST' on port 3306..."
until nc -z "$WORDPRESS_DB_HOST" 3306; do
    echo "Database is not yet available. Retrying in 2 seconds..."
    sleep 2
done
echo "Database port is open. Proceeding with configuration."

cd /var/www/html

if [ -f wp-config.php ]; then
    echo "WordPress is already configured."
else
    echo "Configuring WordPress..."

    # Download wp-cli if not present
    if ! command -v wp &> /dev/null; then
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod +x wp-cli.phar
        mv wp-cli.phar /usr/local/bin/wp
    fi

    wp config create --allow-root \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --path='/var/www/html'

    wp core install --allow-root \
        --url="https://jeandrad.42.fr" \
        --title="Inception" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --path='/var/www/html'

    echo "Installing and configuring Redis..."
    wp plugin install redis-cache --activate --allow-root
    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --allow-root
    wp redis enable --allow-root

    echo "WordPress configured successfully."
fi

# Ensure permissions are always correct for the web server
chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM..."
# Execute the command passed to the script (CMD from Dockerfile)
exec "$@"
