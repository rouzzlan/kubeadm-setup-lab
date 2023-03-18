#!/bin/bash

if ! [ "$USER" = root ]; then
  echo run this script with sudo
  exit 3
fi

sudo mkdir /root/certs && cd /root/certs || exit


openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=BE/ST=Antwerp/L=Antwerp/O=example/OU=Personal/CN=local-harbour-repo.net" \
 -key ca.key \
 -out ca.crt
openssl genrsa -out local-harbour-repo.net.key 4096
openssl req -sha512 -new \
    -subj "/C=BE/ST=Antwerp/L=Antwerp/O=example/OU=Personal/CN=local-harbour-repo.net" \
    -key local-harbour-repo.net.key \
    -out local-harbour-repo.net.csr

cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=local-harbour-repo.net
DNS.2=local-harbour-repo
EOF

openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in local-harbour-repo.net.csr \
    -out local-harbour-repo.net.crt