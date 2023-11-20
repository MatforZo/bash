#!/bin/bash

#Save this script in a file (e.g., wordpress_setup_interactive.sh), make it executable (chmod +x wordpress_setup_interactive.sh), and run it (./wordpress_setup.sh).

# Update system
sudo apt update -y
sudo apt upgrade -y

# Install LAMP stack
sudo apt install apache2 mysql-server php libapache2-mod-php php-mysql -y

# Secure MySQL installation
sudo mysql_secure_installation

# Create a MySQL database and user for WordPress
read -p "Enter WordPress database name: " dbname
read -p "Enter WordPress database user: " dbuser
read -sp "Enter password for MySQL user: " dbpassword

sudo mysql -e "CREATE DATABASE $dbname;"
sudo mysql -e "CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$dbpassword';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Download and configure WordPress
sudo rm -rf /var/www/html/*
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -zxvf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo rm -rf latest.tar.gz wordpress

# Configure Apache for WordPress
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/wordpress.conf
sudo sed -i 's/\/var\/www\/html/\/var\/www\/html\/wordpress/g' /etc/apache2/sites-available/wordpress.conf
sudo a2ensite wordpress.conf
sudo a2enmod rewrite
sudo systemctl restart apache2

# Clean up
sudo apt autoremove -y
sudo apt clean

echo "WordPress installation complete. Visit http://your_server_ip/ to complete the setup."
