#!/bin/bash
# This script installs the requirements for the Helix installation.

clear				# clear terminal window

echo "Updating Ubuntu"

sudo apt -y update
sudo apt -y upgrade

echo "Ubuntu is updated!"

echo "Installing Docker Engine and Docker compose."

# Install prerequisites
sudo apt-get -y update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common

# Add docker's package signing key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add repository
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install latest stable docker stable version
sudo apt-get -y update
sudo apt-get -y install docker-ce

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod a+x /usr/local/bin/docker-compose

# Enable & start docker
sudo systemctl enable docker
sudo systemctl start docker

echo "Docker Engine and Docker compose installed with success."

echo "Pulling Docker Images"

sudo docker pull mongo:3.4
sudo docker pull fiware/orion:latest
sudo docker pull fiware/cygnus-ngsi:1.9.0
sudo docker pull m4n3dw0lf/dtls-lightweightm2m-iotagent

echo "Images pulled with success"

echo "Creating Keys"
sudo mkdir -p /opt/secrets
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /opt/secrets/ssl_key -out /opt/secrets/ssl_crt

echo "Installing Helix Sandbox"

git clone https://github.com/fabiocabrini/helix-sandbox.git
cd helix-sandbox/compose
echo "put_here_your_encryption_key" > secrets/aes_key.txt
sudo docker-compose up -d

echo "Helix installed with success"
