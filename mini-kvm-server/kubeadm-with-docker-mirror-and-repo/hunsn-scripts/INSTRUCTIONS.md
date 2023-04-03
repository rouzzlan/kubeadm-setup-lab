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
init master node
```bash
sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --cri-socket unix:///var/run/cri-dockerd.sock \
  --control-plane-endpoint=k8s-a-master-node.739.net
```
run as `regular user`
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
login back as `root`
```bash
export KUBECONFIG=/etc/kubernetes/admin.conf
```
connect nodes to the master node
```bash
kubeadm join k8s-a-master-node.739.net:6443 --token nzibkj.688a2k8jbk7pq8tw \
	--discovery-token-ca-cert-hash sha256:413aca3edbd64e0c83e90be1a7ec45adf62c7ab64e67bc14188eb4361b86ca0c \
	--cri-socket unix:///var/run/cri-dockerd.sock
```