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

# Installing Helix Sandbox with MQTT
if [[ $type -eq 2 ]]
then
  echo "Installing Helix Sandbox with MQTT"
  git clone https://github.com/fabiocabrini/Helix_IoT_MQTT.git
  cd Helix_IoT_MQTT
  rm -rf docker-compose.yml

  echo 'Enter the IP address of the server'
  read MYIP
  echo 'Enter local ip'
  read MYIPlocal

  #creating docker-compose.yml
  
  echo '# WARNING: Do not deploy this tutorial configuration directly to a production environment' >> docker-compose.yml
  echo '#' >> docker-compose.yml
  echo '# The tutorial docker-compose files have not been written for production deployment and will not' >> docker-compose.yml
  echo '# scale. A proper architecture has been sacrificed to keep the narrative focused on the learning' >> docker-compose.yml
  echo '# goals, they are just used to deploy everything onto a single Docker machine. All FIWARE components' >> docker-compose.yml
  echo '# are running at full debug and extra ports have been exposed to allow for direct calls to services.' >> docker-compose.yml
  echo '# They also contain various obvious security flaws - passwords in plain text, no load balancing,' >> docker-compose.yml
  echo '# no use of HTTPS and so on.' >> docker-compose.yml
  echo '#' >> docker-compose.yml
  echo '# This is all to avoid the need of multiple machines, generating certificates, encrypting secrets' >> docker-compose.yml
  echo '# and so on, purely so that a single docker-compose file can be read as an example to build on,' >> docker-compose.yml
  echo '# not use directly.' >> docker-compose.yml
  echo '# https://gethelix.org' >> docker-compose.yml
  echo '  ' >> docker-compose.yml
  echo 'version: "3.5"' >> docker-compose.yml
  echo 'services:' >> docker-compose.yml
  echo '  '
  echo '  # IoT-Agent is configured for the UltraLight Protocol' >> docker-compose.yml
  echo '  iot-agent:' >> docker-compose.yml
  echo '    image: fiware/iotagent-ul:1.8.0 # iotagent' >> docker-compose.yml
  echo '    hostname: iot-agent' >> docker-compose.yml
  echo '    container_name: fiware-iot-agent' >> docker-compose.yml
  echo '    depends_on:' >> docker-compose.yml
  echo '      - mongo-db' >> docker-compose.yml
  echo '      - mosquitto' >> docker-compose.yml
  echo '    networks:' >> docker-compose.yml
  echo '      - default' >> docker-compose.yml
  echo '    expose:' >> docker-compose.yml
  echo '      - "4041"' >> docker-compose.yml
  echo '    ports:' >> docker-compose.yml
  echo '      - "4041:4041"' >> docker-compose.yml
  echo '    environment:' >> docker-compose.yml
  echo "      - IOTA_CB_HOST=$MYIPlocal # Put Helix Sandbox IP here" >> docker-compose.yml
  echo '      - IOTA_CB_PORT=1026 # port the context broker listens on to update context' >> docker-compose.yml
  echo '      - IOTA_NORTH_PORT=4041' >> docker-compose.yml
  echo '      - IOTA_REGISTRY_TYPE=mongodb #Whether to hold IoT device info in memory or in a database' >> docker-compose.yml
  echo '      - IOTA_LOG_LEVEL=DEBUG # The log level of the IoT Agent' >> docker-compose.yml
  echo '      - IOTA_TIMESTAMP=true # Supply timestamp information with each measurement' >> docker-compose.yml
  echo '      - IOTA_CB_NGSI_VERSION=v2 # use NGSIv2 when sending updates for active attributes' >> docker-compose.yml
  echo '      - IOTA_AUTOCAST=true # Ensure Ultralight number values are read as numbers not strings' >> docker-compose.yml
  echo '      - IOTA_MONGO_HOST=mongo-db # The host name of MongoDB' >> docker-compose.yml
  echo '      - IOTA_MONGO_PORT=27017 # The port mongoDB is listening on' >> docker-compose.yml
  echo '      - IOTA_MONGO_DB=iotagentul # The name of the database used in mongoDB' >> docker-compose.yml
  echo '      - IOTA_MQTT_HOST=mosquitto # The host name of the MQTT Broker' >> docker-compose.yml
  echo '      - IOTA_MQTT_PORT=1883 # The port the MQTT Broker is listening on to receive topics' >> docker-compose.yml
  echo '  #   - IOTA_DEFAULT_RESOURCE=' >> docker-compose.yml
  echo "      - IOTA_PROVIDER_URL=http://$MYIP:4041 #Put Helix IoT IP here" >> docker-compose.yml
  echo '    healthcheck:' >> docker-compose.yml
  echo "      test: curl --fail -s http://$MYIP:4041/iot/about || exit 1 #Put Helix IoT IP here" >> docker-compose.yml
  echo '' >> docker-compose.yml
  echo ' # Database' >> docker-compose.yml
  echo ' mongo-db:' >> docker-compose.yml
  echo '   image: mongo:3.6' >> docker-compose.yml
  echo '    hostname: mongo-db' >> docker-compose.yml
  echo '    container_name: db-mongo' >> docker-compose.yml
  echo '    expose:' >> docker-compose.yml
  echo '      - "27017"' >> docker-compose.yml
  echo '    ports:' >> docker-compose.yml
  echo '      - "27017:27017"' >> docker-compose.yml
  echo '    networks:' >> docker-compose.yml
  echo '      - default' >> docker-compose.yml
  echo '    command: --bind_ip_all --smallfiles' >> docker-compose.yml
  echo '    volumes:' >> docker-compose.yml
  echo '      - mongo-db:/data' >> docker-compose.yml
  echo '' >> docker-compose.yml
  echo '  # Other services' >> docker-compose.yml
  echo '  mosquitto:' >> docker-compose.yml
  echo '    image: eclipse-mosquitto' >> docker-compose.yml
  echo '    hostname: mosquitto' >> docker-compose.yml
  echo '    container_name: mosquitto' >> docker-compose.yml
  echo '    expose:' >> docker-compose.yml
  echo '      - "1883"' >> docker-compose.yml
  echo '      - "9001"' >> docker-compose.yml
  echo '    ports:' >> docker-compose.yml
  echo '      - "1883:1883"' >> docker-compose.yml
  echo '      - "9001:9001"' >> docker-compose.yml
  echo '    volumes:' >> docker-compose.yml
  echo '      - ./mosquitto/mosquitto.conf:/mosquitto/config/mosquitto.conf' >> docker-compose.yml
  echo '    networks:' >> docker-compose.yml
  echo '      - default' >> docker-compose.yml
  echo '  networks:' >> docker-compose.yml
  echo '    default:' >> docker-compose.yml
  echo '      ipam:' >> docker-compose.yml
  echo '        config:' >> docker-compose.yml
  echo '          - subnet: 172.18.1.0/24' >> docker-compose.yml
  echo '' >> docker-compose.yml
  echo '  volumes:' >> docker-compose.yml
  echo '    mongo-db: ~' >> docker-compose.yml
  echo '' >> docker-compose.yml
#finish creating docker-compose.yml

chmod +x docker-compose.yml

  sudo docker-compose up -d

else

  echo "Installing Helix Sandbox with COaP"
  echo "Pulling Docker Images"

  sudo docker pull mongo:3.4
  sudo docker pull fiware/orion:latest
  sudo docker pull fiware/cygnus-ngsi:1.9.0
  sudo docker pull m4n3dw0lf/dtls-lightweightm2m-iotagent

  echo "Images pulled with success"

  echo "Creating Keys"
  sudo mkdir -p /opt/secrets
  sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /opt/secrets/ssl_key -out /opt/secrets/ssl_crt "/C=BR /ST=SP /L=SP /O=Personal /OU=Personal /CN=Helix"

  git clone https://github.com/fabiocabrini/helix-sandbox.git
  cd helix-sandbox/compose
  echo "put_here_your_encryption_key" > secrets/aes_key.txt
  sudo docker-compose up -d
fi

echo "Helix installed with success"
