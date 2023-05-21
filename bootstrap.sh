#! /usr/bin/env bash

# Install Docker
# https://docs.docker.com /engine/install/ubuntu/
sudo apt-get update
sudo groupadd docker
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o \
/etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker $USER
newgrp docker
sudo apt-get install -y docker.io
#trivy
sudo apt-get install -y wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install -y trivy

# Install Kubectl
curl -LO https://dl.k8s.io/release/v1.24.4/bin/linux/amd64/kubectl
curl -LO https://dl.k8s.io/release/v1.24.4/bin/linux/amd64/kubectl.sha256
echo "$(cat kubectl.sha256) kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# Install Helm
curl -LO https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz
sudo tar zxvf helm-v3.6.3-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm

# Install Nmap
sudo apt-get install -y nmap

# Install Minikube
# https://minikube.sigs.k8s.io/docs/start/
curl -LO https://storage.googleapis.com/minikube/releases/v1.26.1/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
# Install calico network plugin for Minikube
curl https://docs.projectcalico.org/manifests/calico-typha.yaml -o calico.yaml
kubectl apply -f calico.yaml
# Minikube start
minikube start --driver=none

