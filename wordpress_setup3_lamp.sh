#!/bin/bash

# Update system
sudo apt update

# Install LAMP stack
sudo apt install apache2 mysql-server php libapache2-mod-php php-mysql -y

# Secure MySQL installation
sudo mysql_secure_installation <<EOF

n
y
y
y
y
EOF

# Set variables for database settings
dbname="wordpress"
dbuser="wordpress@localhost"
dbpassword="admin123"

# Create a MySQL database and user for WordPress
sudo mysql -e "CREATE DATABASE $dbname;"
sudo mysql -e "CREATE USER '$dbuser' IDENTIFIED BY '$dbpassword';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Download and configure WordPress
sudo rm -rf /var/www/html/*
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -zxvf latest.tar.gz -C /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo rm -rf latest.tar.gz

# Configure Apache for WordPress
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/wordpress.conf
sudo sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/wordpress/g' /etc/apache2/sites-available/wordpress.conf
sudo a2ensite wordpress.conf
sudo a2enmod rewrite
sudo systemctl restart apache2

# Clean up
sudo apt autoremove -y
sudo apt clean

echo "WordPress installation complete. Visit http://your_server_ip/ to complete the setup."
