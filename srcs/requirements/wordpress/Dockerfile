# Use the penultimate stable version of Debian
FROM debian:bookworm-slim

# Install dependencies, PHP, and its extensions
RUN apt-get update && apt-get install -y \
    curl \
    mariadb-client \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-gd \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Copy the custom PHP-FPM configuration from the tools directory
COPY ./tools/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copy the configuration script
COPY ./tools/configure-wp.sh /usr/local/bin/configure-wp.sh
RUN chmod +x /usr/local/bin/configure-wp.sh

# Download WordPress to a temporary location
RUN curl -o /usr/src/wordpress.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xvzf /usr/src/wordpress.tar.gz -C /usr/src/ \
    && rm /usr/src/wordpress.tar.gz

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Set the entrypoint to your script
ENTRYPOINT ["/usr/local/bin/configure-wp.sh"]

# The CMD is what the entrypoint will execute at the end.
# We use the -F flag to run php-fpm in the foreground.
CMD ["/usr/sbin/php-fpm8.2", "-F"]
