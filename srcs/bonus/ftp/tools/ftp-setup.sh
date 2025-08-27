#!/bin/bash
set -e

# Create the user if it doesn't exist, using variables from the .env file
if ! id -u "$FTP_USER" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "$FTP_USER"
fi

# Set the password for the user
echo "$FTP_USER:$FTP_PASS" | chpasswd

# Start the vsftpd daemon in the foreground
echo "Starting vsftpd..."
/usr/sbin/vsftpd /etc/vsftpd.conf
