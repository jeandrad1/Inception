# Use the official MariaDB image
FROM mariadb:latest

# Override the default entrypoint to add user creation commands
# The script will create users when the container starts
ENTRYPOINT ["sh", "-c", "
    # Create the database
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e 'CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};' && \
    
    # Create the WordPress user and grant privileges
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e 'CREATE USER IF NOT EXISTS \"${MYSQL_USER}\"@\"%\" IDENTIFIED BY \"${MYSQL_PASSWORD}\";' && \
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e 'GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO \"${MYSQL_USER}\"@\"%\";' && \

    # Create the custom admin user and grant privileges
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e 'CREATE USER IF NOT EXISTS \"${MARIADB_ADMIN_USER}\"@\"%\" IDENTIFIED BY \"${MARIADB_ADMIN_PASSWORD}\";' && \
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e 'GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO \"${MARIADB_ADMIN_USER}\"@\"%\";' && \

    # Flush privileges
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e 'FLUSH PRIVILEGES;' && \

    # Execute the original entrypoint for MariaDB to continue starting normally
    /entrypoint.sh mysqld
"]

# Expose MariaDB port
EXPOSE 3306
