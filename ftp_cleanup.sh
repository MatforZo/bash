#!/bin/bash

# Stop vsftpd service
sudo service vsftpd stop

# Remove vsftpd
sudo apt purge -y vsftpd
sudo apt autoremove -y

# Restore the original vsftpd.conf file
sudo mv /etc/vsftpd.conf.bak /etc/vsftpd.conf

# Remove the FTP user 'ftpuser'
sudo userdel -r ftpuser

# Remove the FTP directory
sudo rm -rf /var/www

# If needed, disable UFW and remove FTP rules (uncomment if UFW is used)
# sudo ufw delete allow 20/tcp
# sudo ufw delete allow 21/tcp
# sudo ufw delete allow 1024:1048/tcp
# sudo ufw disable

echo "Cleanup complete. The server is now back to its original state before running the FTP setup script."
