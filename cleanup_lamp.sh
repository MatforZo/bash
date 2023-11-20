#!/bin/bash

# Stop Apache
sudo systemctl stop apache2

# Remove Apache
sudo apt purge apache2 apache2-utils -y
sudo apt autoremove -y

# Remove MySQL
sudo apt purge mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-* -y
sudo rm -rf /etc/mysql /var/lib/mysql
sudo apt autoremove -y

# Remove PHP
sudo apt purge php libapache2-mod-php php-mysql -y
sudo apt autoremove -y

# Remove Apache and PHP configuration files
sudo rm -rf /etc/apache2 /etc/php

echo "LAMP stack removed successfully."
