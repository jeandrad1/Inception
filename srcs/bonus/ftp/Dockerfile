# Use the penultimate stable version of Debian
FROM debian:bookworm

# Install vsftpd
RUN apt-get update && apt-get install -y vsftpd && rm -rf /var/lib/apt/lists/*

# Copy the configuration file
COPY vsftpd.conf /etc/vsftpd.conf

# Copy the setup script
COPY tools/ftp-setup.sh /usr/local/bin/ftp-setup.sh
RUN chmod +x /usr/local/bin/ftp-setup.sh

# Create the directory for the secure chroot jail
RUN mkdir -p /var/run/vsftpd/empty

# Expose the FTP command port and the passive port range
EXPOSE 21 21100-21110

# Set the entrypoint to the setup script
ENTRYPOINT ["/usr/local/bin/ftp-setup.sh"]
