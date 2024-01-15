#!/bin/bash

# Update the package index
sudo apt update

# Set the DEBIAN_FRONTEND variable to noninteractive
export DEBIAN_FRONTEND=noninteractive

# Install Java (OpenJDK 11)
sudo apt install -y openjdk-11-jdk

# Download the Jenkins repository key and install Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins

# Start Jenkins service
sudo systemctl start jenkins

# Enable Jenkins to start on boot
sudo systemctl enable jenkins

# Display initial Jenkins admin password
echo "Wait a moment for Jenkins to start..."
sleep 30 # Wait for Jenkins to fully start
echo "Jenkins initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

