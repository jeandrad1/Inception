# Use a Debian image
FROM debian

# Install vsftpd (Very Secure FTP Daemon)
RUN apt-get update && apt-get install -y vsftpd

# IMPORTANT: This creates a user with a hardcoded password for demonstration.
# In a real-world scenario, you should use Docker secrets or environment
# variables to handle credentials securely.
RUN useradd -m -s /bin/bash ftpuser && echo "ftpuser:ftppass" | chpasswd

# Copy the configuration file into the container
COPY vsftpd.conf /etc/vsftpd.conf

# Create the directory for the secure chroot jail
RUN mkdir -p /var/run/vsftpd/empty

# Expose the FTP command port and the passive port range
EXPOSE 21 21100-21110

# The command to start the vsftpd server in the foreground
CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]
