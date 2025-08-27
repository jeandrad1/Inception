FROM debian

# Install vsftpd (Very Secure FTP Daemon)
RUN apt-get update && apt-get install -y vsftpd

# REMOVED: The hardcoded user creation is now handled by the entrypoint script
# RUN useradd -m -s /bin/bash ftpuser && echo "ftpuser:ftppass" | chpasswd

# Copy the configuration file into the container
COPY vsftpd.conf /etc/vsftpd.conf

# Copy the new setup script
COPY tools/ftp-setup.sh /usr/local/bin/ftp-setup.sh
RUN chmod +x /usr/local/bin/ftp-setup.sh

# Create the directory for the secure chroot jail
RUN mkdir -p /var/run/vsftpd/empty

# Expose the FTP command port, data port, and the passive port range
EXPOSE 20 21 21100-21110

# Set the entrypoint to the setup script
ENTRYPOINT ["/usr/local/bin/ftp-setup.sh"]
