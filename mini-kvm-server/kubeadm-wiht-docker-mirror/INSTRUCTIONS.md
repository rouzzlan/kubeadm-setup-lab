# Setup instructions
### Color scheme
- <span style="color:purple">Host server</span>
- <span style="color:blue">Master and Slave nodes</span>
- <span style="color:red">Master node</span>
- <span style="color:green">Slave node</span>

## <span style="color:purple">Host server setup</span>
### <span style="color:purple">configure name references</span>
```bash
sudo vim /etc/hosts
```
add content
```text
# k8s cluster a
192.168.122.135 k8s-master-a.local
192.168.122.136 k8s-node-1-a.local
192.168.122.137 k8s-node-2-a.local
192.168.122.138 k8s-node-3-a.local

```
### <span style="color:purple">configure NGINX</span>
```bash
sudo vim /etc/nginx/stream.conf.d/k8s-a.conf
```

```text
upstream k8s-master-a {
  server k8s-master-a.local:22;
}

server {
  listen 22020;
  proxy_pass k8s-master-a;
}


upstream k8s-node-1-a {
  server k8s-node-1-a.local:22;
}

server {
  listen 22021;
  proxy_pass k8s-node-1-a;
}


upstream k8s-node-2-a {
  server k8s-node-2-a.local:22;
}

server {
  listen 22022;
  proxy_pass k8s-node-2-a;
}


upstream k8s-node-3-a {
  server k8s-node-3-a.local:22;
}

server {
  listen 22023;
  proxy_pass k8s-node-3-a;
}
```
Reconfigure NGINX
```bash
sudo nginx -T
sudo systemctl restart nginx
sudo systemctl status nginx
```


## <span style="color:blue">On all nodes</span>
### <span style="color:blue">install some base packages</span>
```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install qemu-guest-agent -y
sudo systemctl start qemu-guest-agent.service
```
### <span style="color:blue">Hosts file</span>
```bash
sudo vim /etc/hosts
```
add content
```text
192.168.122.135 k8s-master.local
192.168.122.136 k8s-node-1.local
192.168.122.137 k8s-node-2.local
192.168.122.138 k8s-node-3.local
192.168.122.11 mirror.local
192.168.122.23 local-harbour-repo.net
```


install docker
```bash
sudo sh 1-script.sh
```
install docker tools
```bash
sudo sh 2-script.sh
```
verify
```bash
cri-dockerd --version
sudo docker system info
```
install kubeadm
```bash
sudo sh 3-script.sh
```
pull images
```bash
sudo kubeadm config images pull --cri-socket unix:///var/run/cri-dockerd.sock
```
## <span style="color:red">Master node</span>
setup cluster
```bash
sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --cri-socket unix:///var/run/cri-dockerd.sock \
  --control-plane-endpoint=k8s-master.local
```
add user acces to kubeadm cluster
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
for admin
```bash
export KUBECONFIG=/etc/kubernetes/admin.conf
```
## <span style="color:green">Slave node</span>
The connection script is generated run it on every node.
```bash
kubeadm join k8s-master.local:6443 --token vm7599.9vy09uslchlhgokf \
	--discovery-token-ca-cert-hash sha256:1c035525daad49764394b25114ee51bb647945cf88a3b2d93cef2c1480986f68 
```