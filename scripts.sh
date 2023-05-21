#!/bin/bash
# Install Docker
# https://docs.docker.com/engine/install/ubuntu/
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose
sudo usermod -aG docker $USER
newgrp docker
# Install Kubectl
curl -LO https://dl.k8s.io/release/v1.24.4/bin/linux/amd64/kubectl
curl -LO https://dl.k8s.io/release/v1.24.4/bin/linux/amd64/kubectl.sha256
echo "$(cat kubectl.sha256) kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# Install Helm
wget https://get.helm.sh/helm-v3.10.1-linux-amd64.tar.gz
sudo tar zxvf helm-v3.10.1-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
