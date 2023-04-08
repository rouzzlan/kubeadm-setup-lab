#!/bin/bash

if ! [ "$USER" = root ]; then
  echo run this script with sudo
  exit 3
fi

sudo mkdir -p /etc/containerd/certs.d/
sudo mkdir /etc/containerd/certs.d/harbour.739.net
sudo mkdir /etc/containerd/certs.d/_default
sudo mkdir /etc/containerd/certs.d/registry.k8s.io
sudo mkdir /etc/containerd/certs.d/docker.io


sudo tee /etc/containerd/certs.d/_default/hosts.toml <<EOF
server = "https://docker.io"

[host."https://registry-1.docker.io"]
  capabilities = ["pull", "resolve"]
EOF

sudo tee /etc/containerd/certs.d/docker.io/hosts.toml <<EOF
server = "https://docker.io"

[host."https://registry-1.docker.io"]
  capabilities = ["pull", "resolve"]
EOF

sudo tee /etc/containerd/certs.d/registry.k8s.io/hosts.toml <<EOF
server = "https://registry.k8s.io"

[host."https://registry.k8s.io"]
  capabilities = ["pull", "resolve"]
EOF


sudo tee /etc/containerd/certs.d/harbour.739.net/ca.crt <<EOF
-----BEGIN CERTIFICATE-----
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
-----END CERTIFICATE-----
EOF

sudo tee /etc/containerd/certs.d/harbour.739.net/hosts.toml <<EOF
server = "https://harbour.739.net"

[host."https://harbour.739.net"]
    capabilities = ["pull", "resolve"]
    ca = ["/etc/containerd/certs.d/harbour.739.net/ca.crt"]
EOF



sudo systemctl restart containerd