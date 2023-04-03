# Additional instructions
Install instructions for k8s on hunsn server (Apr 3 2023)
```bash
sudo mkdir -p /etc/docker/certs.d/harbour.739.net && cd /etc/docker/certs.d/harbour.739.net
```

## Install by script
if needed, install the required software
```bash
sudo apt install xz-utils
```
unzip
```bash
tar -xvf certificate-import.tar.xz
```
run the script as root.</br>
the contents of folder should be as following:
```text
/etc/docker/certs.d/
└── harbour.739.net
    ├── ca.crt
    ├── harbour.739.net.cert
    └── harbour.739.net.key

1 directory, 3 files
```

