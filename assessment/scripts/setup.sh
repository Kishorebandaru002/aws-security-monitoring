#!/bin/bash

#Exit immediately if a command fails or a variable is undefined
set -euo pipefail

#Print each command for debugging
set -x

echo "Starting Wazuh Setup Script..."

#Update the system
sudo apt-get update -y
sudo apt-get upgrade -y

#Install required dependencies
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gnupg-agent \
    lsb-release \
    git

#Install Docker CE
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

#Start and enable Docker
sudo systemctl enable docker
sudo systemctl start docker

#Install Docker Compose (latest version)
DOCKER_COMPOSE_VERSION="2.24.1"
sudo curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

#Verify Docker + Compose
docker --version
docker-compose --version

#Clone official Wazuh Docker deployment
cd /opt
sudo git clone https://github.com/wazuh/wazuh-docker.git
cd wazuh-docker

#Start Wazuh with Docker Compose
cd single-node
sudo docker-compose up -d

echo " Wazuh deployment complete!"
