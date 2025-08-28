# Penultimate stable version of Debian
FROM debian:bookworm

# Install NGINX
RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

# Copy the static content into the default NGINX public directory
COPY . /var/www/html/

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
