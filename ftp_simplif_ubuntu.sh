#!/bin/bash
#Prerequsites: open up the FTP ports on your remote machine
# e.g. ec2 AWS instancce go to security groups and allow traffic as bellow:
# TCP 20 - 21 & TCP 1024 - 1048

# Default password for 'ftpuser'
FTPUSER_PASSWORD="ftpuserpass123"

# Get public IP address using curl and ifconfig.me
public_ip=$(curl -s ifconfig.me)

# Install vsftpd and UFW
sudo apt update
sudo apt install -y vsftpd 

#uncomment if it's not cloud based instance to install uncomplicated firewall
#sudo apt install -y ufw

# Backup the original configuration file
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak

# Configure vsftpd to use /var/www/html/ as the remote directory
sudo cat > /etc/vsftpd.conf <<EOF
listen=NO
listen_ipv6=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
chown_uploads=YES
chown_username=whoever
idle_session_timeout=600
data_connection_timeout=120
nopriv_user=ftpsecure
async_abor_enable=YES
ascii_upload_enable=YES
ascii_download_enable=YES
ftpd_banner=Welcome to blah FTP service.
deny_email_enable=YES
chroot_local_user=YES
chroot_list_enable=YES
ls_recurse_enable=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO
pasv_enable=YES
pasv_min_port=1024
pasv_max_port=1048
pasv_address=$public_ip # Replace with your server's IP address
local_root=/var/www/
utf8_filesystem=YES
EOF
# Restart vsftpd service
sudo service vsftpd restart

# If it's not cloud based instance then Allow FTP traffic in UFW and Enable UFW
#sudo ufw allow 20/tcp
#sudo ufw allow 21/tcp
#sudo ufw allow 1024:1048/tcp
#sudo ufw enable

# Add FTP user 'ftpuser' with home directory '/var/www' and group permissions
sudo useradd -m -d /var/www -G www-data ftpuser
sudo chown ftpuser:www-data /var/www
sudo chmod 775 /var/www

# This sets the owner and group to ftpuser and gives read, write, and execute permissions to the owner and group. Others will have read and execute permissions.
# Change ownership
sudo chown -R ftpuser:ftpuser /var/www
# Adjust permissions
sudo chmod -R 775 /var/www
# Set users ubuntu, root, and ftpuser as members of the ftpuser group 
sudo usermod -aG ftpuser ubuntu
sudo usermod -aG ftpuser root
sudo usermod -aG ftpuser ftpuser

# Set default password for 'ftpuser'
echo "ftpuser:$FTPUSER_PASSWORD" | sudo chpasswd

echo "FTP service and user 'ftpuser' configured successfully"
