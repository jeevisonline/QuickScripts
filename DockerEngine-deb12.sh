#!/bin/bash

if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [ "$ID" == "debian" ] && [ "$VERSION_ID" == "12" ]; then
        echo "System is running Debian 12."
    else
        echo "This script is intended for Debian 12. Exiting."
        exit 2
    fi
else
    echo "Unable to determine the operating system. Exiting."
    exit 2
fi

if command -v docker &> /dev/null; then
    echo "Docker is already installed."
    exit 1
fi


# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

if sudo apt-get install -y docker.io; then
    if sudo docker run hello-world; then
        echo "Hello World container ran successfully."
        exit 0
    else
        echo "Failed to run Hello World container."
        exit 3
fi
else
    echo "Failed to install Docker."
    exit 2
fi
