#!/bin/bash

# Update package index
sudo apt update

# Install necessary packages to allow apt to use a repository over HTTPS
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository to APT sources
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again with the new repository
sudo apt update

# Install Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add the current user to the "docker" group to run Docker commands without sudo
sudo usermod -aG docker ubuntu

# Display Docker version
docker --version

echo "Docker has been installed and configured."
