#!/bin/bash
set -e

# If the data directory is empty, initialize the database
if [ -z "$(ls -A /var/lib/mysql)" ]; then
    echo "Initializing MariaDB..."
    # mariadb-install-db is the new name for mysql_install_db
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Start the MariaDB server in the background
echo "Starting MariaDB server..."
mysqld_safe --user=mysql --datadir=/var/lib/mysql &

# Wait for the server to be ready
until mysqladmin ping --silent; do
    echo "Waiting for MariaDB to start..."
    sleep 2
done

# Create database and user from .env variables if they don't exist
# The SQL commands are idempotent
echo "Creating database and user..."
mariadb -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
    FLUSH PRIVILEGES;
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
EOSQL

# Bring the background server process to the foreground
echo "MariaDB is ready for connections."
wait
