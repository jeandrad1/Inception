FROM mariadb:latest

# We need mysqladmin for the healthcheck defined in docker-compose.yml
RUN apt-get update && apt-get install -y mariadb-client

EXPOSE 3306
