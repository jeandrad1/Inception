# Use official NGINX image
FROM nginx:latest

# Install OpenSSL to generate the SSL certificates
RUN apt-get update && apt-get install -y openssl

# Create a directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Generate the self-signed SSL certificates (using OpenSSL)
RUN openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -days 365 -nodes -subj "/C=US/ST=California/L=SanFrancisco/O=MyCompany/CN=jeandrad.42.fr"

# Configure NGINX for WordPress
RUN echo "server {" > /etc/nginx/conf.d/default.conf && \
    echo "    listen 443 ssl;" >> /etc/nginx/conf.d/default.conf && \
    echo "    server_name jeandrad.42.fr;" >> /etc/nginx/conf.d/default.conf && \
    echo "    ssl_protocols TLSv1.2 TLSv1.3;" >> /etc/nginx/conf.d/default.conf && \
    echo "    ssl_certificate /etc/nginx/ssl/nginx.crt;" >> /etc/nginx/conf.d/default.conf && \
    echo "    ssl_certificate_key /etc/nginx/ssl/nginx.key;" >> /etc/nginx/conf.d/default.conf && \
    echo "    root /var/www/html;" >> /etc/nginx/conf.d/default.conf && \
    echo "    index index.php index.html index.htm;" >> /etc/nginx/conf.d/default.conf && \
    echo "    location / {" >> /etc/nginx/conf.d/default.conf && \
    echo "        try_files \$uri \$uri/ /index.php?\$args;" >> /etc/nginx/conf.d/default.conf && \
    echo "    }" >> /etc/nginx/conf.d/default.conf && \
    echo "    location ~ \.php$ {" >> /etc/nginx/conf.d/default.conf && \
    echo "        include fastcgi_params;" >> /etc/nginx/conf.d/default.conf && \
    echo "        fastcgi_pass wordpress:9000;" >> /etc/nginx/conf.d/default.conf && \
    echo "        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;" >> /etc/nginx/conf.d/default.conf && \
    echo "    }" >> /etc/nginx/conf.d/default.conf && \
    echo "}" >> /etc/nginx/conf.d/default.conf

# Expose port 443 for HTTPS
EXPOSE 443

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
