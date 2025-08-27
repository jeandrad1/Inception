#!/bin/bash
set -e

# Check if the WordPress directory is empty. If so, copy the files.
# This handles the first run when using a host-mounted volume.
if [ -z "$(ls -A /var/www/html)" ]; then
	echo "WordPress directory is empty. Copying files from /usr/src/wordpress..."
	cp -r /usr/src/wordpress/* /var/www/html/
fi

# Wait for the database to be ready
until mysqladmin ping -h"$WORDPRESS_DB_HOST" -u"root" -p"$MYSQL_ROOT_PASSWORD" --silent; do
	echo "Waiting for database..."
	sleep 2
done

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
