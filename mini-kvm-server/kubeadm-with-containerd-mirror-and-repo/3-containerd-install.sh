#!/bin/bash

if ! [ $USER = root ]; then
  echo run this script with sudo
  exit 3
fi

# Add repo and Install packages
sudo apt update
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

sudo tee /etc/modules-load.d/containerd.conf << EOF
overlay
br_netfilter
EOF

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y containerd.io

# Configure containerd and start service
mkdir -p /etc/containerd
containerd config default>/etc/containerd/config.toml

# Start and enable Services
sudo systemctl daemon-reload
sudo systemctl restart containerd
sudo systemctl enable containerd