

install docker tools
```bash
sudo sh 2-script.sh
```
verify
```bash
cri-dockerd --version
```
install kubeadm
```bash
sudo sh 3-script.sh
```
pull images
```bash
sudo kubeadm config images pull --cri-socket unix:///var/run/cri-dockerd.sock
```
setup cluster
```bash
sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --cri-socket unix:///var/run/cri-dockerd.sock
```