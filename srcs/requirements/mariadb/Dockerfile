# Use the official MariaDB image
FROM mariadb:latest

# Install mysql-client to ensure mysqladmin is available
RUN apt-get update && apt-get install -y mariadb-client

# Override the default entrypoint to add user creation commands
# The script will start mysqld, wait for it, create users, and then keep mysqld running.
ENTRYPOINT ["sh", "-c", " \
    /usr/local/bin/docker-entrypoint.sh mysqld & \
    pid=\"$!\"; \
    while ! mysqladmin ping -h'localhost' -u'root' -p\"${MYSQL_ROOT_PASSWORD}\" --silent; do \
        sleep 1; \
    done; \
    mysql -u root -p\"${MYSQL_ROOT_PASSWORD}\" -e \" \
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`; \
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'; \
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%'; \
        CREATE USER IF NOT EXISTS '${MARIADB_ADMIN_USER}'@'%' IDENTIFIED BY '${MARIADB_ADMIN_PASSWORD}'; \
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MARIADB_ADMIN_USER}'@'%'; \
        FLUSH PRIVILEGES; \
    \"; \
    wait \"$pid\"; \
"]

# Expose MariaDB port
EXPOSE 3306