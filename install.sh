#!/bin/bash
# This script installs the requirements for the Helix installation.

clear				# clear terminal window

echo "Updating Ubuntu"
echo

sudo apt -y update
sudo apt -y upgrade

echo "Ubuntu is updated!"

echo

echo "Installing Docker Engine and Docker compose."

echo

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

echo
