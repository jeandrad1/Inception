# Use the penultimate stable version of Debian
FROM debian:bookworm-slim

# Install MariaDB server and client
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Copy the setup script
COPY tools/db-setup.sh /usr/local/bin/db-setup.sh
RUN chmod +x /usr/local/bin/db-setup.sh

# Expose the default MariaDB port
EXPOSE 3306

# Run the setup script
ENTRYPOINT ["/usr/local/bin/db-setup.sh"]
