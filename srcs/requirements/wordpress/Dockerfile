# Use official PHP image with FPM support
FROM php:8.1-fpm

# Install required dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
	curl \
	libfcgi-bin \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql mysqli

	
# Install Composer for managing dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory inside the container
WORKDIR /var/www/html

# Download WordPress and set proper permissions
RUN curl -O https://wordpress.org/latest.tar.gz \
    && tar -xvzf latest.tar.gz \
    && rm latest.tar.gz \
    && mv wordpress/* . \
    && rmdir wordpress \
    && chown -R www-data:www-data /var/www/html

# Copy the configuration script into the container
COPY ./tools/configure-wp.sh /usr/local/bin/configure-wp.sh
RUN chmod +x /usr/local/bin/configure-wp.sh

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Run the configuration script
CMD ["/usr/local/bin/configure-wp.sh"]
