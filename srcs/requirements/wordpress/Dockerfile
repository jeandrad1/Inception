# Use official PHP image with FPM support
FROM php:8.1-fpm

# Install required dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

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

# Configure PHP-FPM settings (basic config for WordPress)
RUN echo "cgi.fix_pathinfo=0" > /usr/local/etc/php/conf.d/99-custom.ini

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Run PHP-FPM (no need for nginx or apache)
CMD ["php-fpm"]
