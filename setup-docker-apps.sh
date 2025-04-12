#!/bin/bash

# This script is licensed under the GNU General Public License v3.0
# See LICENSE file for details.

# Clear screen and start installation process
clear
echo "### Preparing for Installation ###"
sleep 2s

# Remove conflicting packages for Docker Engine
echo 'Removing conflicting packages for Docker Engine...'
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done > ~/script-install.log 2>&1

# Ensure system updates are applied
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install prerequisite packages
echo "Installing required dependencies..."
sudo apt install -y curl wget git

# Setup Docker's apt repository
echo "Setting Docker's apt repository..."
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install latest version of Docker Engine
echo "Installing Docker Engine..."
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y >> ~/script-install.log 2>&1

# Start and enable Docker service
sudo systemctl enable docker --now

# Add the current user to the Docker group
echo "Adding the current user to the Docker group..."
sudo groupadd docker >> ~/script-install.log 2>&1
sudo usermod -aG docker "${USER}" >> ~/script-install.log 2>&1
# Apply Docker group changes immediately in this session
echo "Applying Docker group permissions..."
sg docker -c "echo Docker group permissions applied successfully."

echo "You'll need to log out and back in for full access, but this session should now have Docker permissions."

# Create main Docker network
echo "Creating Docker network..."
sudo docker network create main-network >> ~/script-install.log 2>&1

# Define the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install Portainer-CE
echo "Setting up Portainer-CE..." >> ~/script-install.log 2>&1
mkdir -p ~/docker/portainer/
cd ~/docker/portainer

COMPOSE_FILE_PORTAINER=~/docker-install/docker-compose_portainer-ce.yml

if [[ -f "$COMPOSE_FILE_PORTAINER" ]]; then
    echo "Found local docker-compose_portainer-ce.yml in ~/docker-install, copying to Portainer directory..." >> ~/script-install.log 2>&1
    cp "$COMPOSE_FILE_PORTAINER" docker-compose.yml >> ~/script-install.log 2>&1
else
    echo "Local compose file not found, downloading from repository..." >> ~/script-install.log 2>&1
    curl -sSL https://github.com/e-duMaurier/docker-setup/blob/main/docker-compose_portainer-ce.yml -o docker-compose.yml >> ~/script-install.log 2>&1
fi

sudo docker compose up -d >> ~/script-install.log 2>&1
cd ~

# Install Nginx Proxy Manager
echo "Setting up Nginx Proxy Manager..." >> ~/script-install.log 2>&1
mkdir -p ~/docker/nginx-proxy-manager
cd ~/docker/nginx-proxy-manager

COMPOSE_FILE_NGINX=~/docker-install/docker-compose_nginx-proxy-manager.yml

if [[ -f "$COMPOSE_FILE_NGINX" ]]; then
    echo "Found local docker-compose_nginx-proxy-manager.yml in ~/docker-install, copying to Nginx Proxy Manager directory..." >> ~/script-install.log 2>&1
    cp "$COMPOSE_FILE_NGINX" docker-compose.yml >> ~/script-install.log 2>&1
else
    echo "Local compose file not found, downloading from repository..." >> ~/script-install.log 2>&1
    curl -sSL https://github.com/e-duMaurier/docker-setup/blob/main/docker-compose_nginx-proxy-manager.yml -o docker-compose.yml >> ~/script-install.log 2>&1
fi

sudo docker compose up -d >> ~/script-install.log 2>&1
cd ~

# Completion message with default login details
echo "### Installation Complete! ###"
echo "Navigate to your server's IP on the following ports to configure your services:"
echo ""
echo "🔹 **Nginx Proxy Manager**"
echo "   - URL: http://<server-ip>:81"
echo "   - Default login:"
echo "     - Username: admin@example.com"
echo "     - Password: changeme"
echo ""
echo "🔹 **Portainer-CE**"
echo "   - URL: http://<server-ip>:9000"
echo "   - You will be prompted to set up your admin account."
echo ""
echo "All services have been installed and are running!"

exit 0
