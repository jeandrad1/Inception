# Penultimate stable version of Debian
FROM debian:bookworm

# Install PHP and curl
RUN apt-get update && apt-get install -y php-cli curl && rm -rf /var/lib/apt/lists/*

# Create web root and download Adminer
RUN mkdir -p /var/www/html
RUN curl -L "https://www.adminer.org/latest.php" -o /var/www/html/index.php

# Expose port 8080
EXPOSE 8080

# Use PHP's built-in web server to serve Adminer
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
