FROM mariadb:latest

# We need mysqladmin for the healthcheck defined in docker-compose.yml
RUN apt-get update && apt-get install -y mariadb-client

# Copy the initialization script. The official entrypoint will execute any .sql
# files found in this directory upon first startup.
COPY ./init-db.sql /docker-entrypoint-initdb.d/

EXPOSE 3306