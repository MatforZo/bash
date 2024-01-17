#!/bin/bash

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker packages:
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose

# Add your user to the 'docker' group to run Docker without sudo
sudo usermod -aG docker $USER
newgrp docker

# Restart Docker or if it's not enought 
# Restart the system or log out and log back in to apply the group changes
sudo service docker restart

# Test Docker installation
docker --version
docker run hello-world

# Automatically start Docker and containerd on boot 
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Install the Compose plugin
sudo apt-get install docker-compose-plugin
