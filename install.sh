#!/bin/bash
# This script installs the requirements for the Helix installation.

clear				# clear terminal window

echo "Welcome to Helix Sandbox Intallation, please chose between one of the following options for proceeding with instalation."

echo

echo "Type [1] for install helix with COaP or type [2] for installing Helix with MQTT"

read type

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
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /opt/secrets/ssl_key -out /opt/secrets/ssl_crt "/C=BR /ST=SP /L=SP /O=Personal /OU=Personal /CN=Helix"

if [[ $type -eq 2 ]]
then
  echo "Installing Helix Sandbox with MQTT"
  git clone https://github.com/fabiocabrini/Helix_IoT_MQTT.git
  cd Helix_IoT_MQTT
  MYIP='hostname -I'
  MYIPPORT='hostname -I'":4041"
  MYIPAdd='hostname -I'":4041/iot/about || exit 1"
  sed 's/\(IOTA_CB_HOST=\).*/\$MYIP/' docker-compose.yml
  sed 's/\(IOTA_PROVIDER_URL=http://\).*/\$MYIPPORT/' docker-compose.yml
  sed 's/\(curl --fail -s http://\).*/\$MYIPAdd/' docker-compose.yml
  sudo docker-compose up -d
else
  echo "Installing Helix Sandbox with COaP"

  git clone https://github.com/fabiocabrini/helix-sandbox.git
  cd helix-sandbox/compose
  echo "put_here_your_encryption_key" > secrets/aes_key.txt
  sudo docker-compose up -d
fi

echo "Helix installed with success"
