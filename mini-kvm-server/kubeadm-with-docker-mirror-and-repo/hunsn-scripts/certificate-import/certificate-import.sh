#!/bin/bash

if ! [ $USER = root ]; then
  echo run this script with sudo
  exit 3
fi

sudo mkdir -p /etc/docker/certs.d/harbour.739.net
sudo mv ./certs/* /etc/docker/certs.d/harbour.739.net/
sudo chown -R root /etc/docker/certs.d/harbour.739.net/