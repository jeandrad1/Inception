# Use the penultimate stable version of Debian
FROM debian:bookworm-slim

# Install NGINX and OpenSSL
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create a directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Generate the self-signed SSL certificates
RUN openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -days 365 -nodes -subj "/C=US/ST=California/L=SanFrancisco/O=MyCompany/CN=jeandrad.42.fr"

# Copy the NGINX configuration file
COPY default.conf /etc/nginx/conf.d/default.conf

# Expose port 443 for HTTPS
EXPOSE 443

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
