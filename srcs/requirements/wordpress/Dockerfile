# Use official PHP image with FPM support
FROM php:8.1-fpm

# Install required dependencies and utilities
RUN apt-get update && apt-get install -y \
	libpng-dev \
	libjpeg-dev \
	libfreetype6-dev \
	zip \
	curl \
	mariadb-client \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install gd pdo pdo_mysql mysqli

# Download WordPress to a temporary location, NOT the final volume mount point.
RUN curl -o /usr/src/wordpress.tar.gz https://wordpress.org/latest.tar.gz \
	&& tar -xvzf /usr/src/wordpress.tar.gz -C /usr/src/ \
	&& rm /usr/src/wordpress.tar.gz

# Copy the configuration script into the container
COPY ./tools/configure-wp.sh /usr/local/bin/configure-wp.sh
RUN chmod +x /usr/local/bin/configure-wp.sh

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Set the entrypoint to your script. This runs every time the container starts.
ENTRYPOINT ["/usr/local/bin/configure-wp.sh"]

# The CMD is the default command that the entrypoint will execute at the end.
CMD ["php-fpm"]
