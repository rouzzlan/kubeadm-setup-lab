#!/bin/bash

if ! [ $USER = root ]; then
  echo run this script with sudo
  exit 3
fi

# Add repo and Install packages
sudo apt update
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y containerd.io docker-ce docker-ce-cli

sudo tee /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": [
            "http://mirrors.739.net:5000"
    ],
    "insecure-registries" : [
            "http://mirrors.739.net:5000",
            "https://harbour.739.net"
    ]
}
EOF


# Start and enable Services
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker
