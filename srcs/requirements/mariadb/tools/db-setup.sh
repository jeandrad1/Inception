#!/bin/bash
set -e

# Ensure the mysql user owns the data and run directories.
chown -R mysql:mysql /var/lib/mysql
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# If the database 'mysql' does not exist, initialize it.
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB for the first time..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Start a temporary server in the background to configure it
    /usr/sbin/mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking &
    pid="$!"

    # Wait for the socket to appear
    i=0
    while ! [ -S /run/mysqld/mysqld.sock ]; do
        sleep 1
        i=$((i+1))
        if [ "$i" -gt 30 ]; then
            echo "MariaDB socket did not appear, aborting."
            exit 1
        fi
    done

    # Run the initial SQL configuration
    mariadb -u root <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
        FLUSH PRIVILEGES;
EOSQL

    # Stop the temporary server gracefully
    echo "Shutting down temporary server..."
    mariadb-admin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait "$pid"
fi

# Start the main MariaDB server process in the foreground
echo "Starting MariaDB server for general use..."
exec /usr/sbin/mariadbd --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
