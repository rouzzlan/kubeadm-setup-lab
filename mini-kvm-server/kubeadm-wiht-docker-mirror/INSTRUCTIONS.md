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
192.168.122.135 k8s-master-a.local
192.168.122.136 k8s-node-1-a.local
192.168.122.137 k8s-node-2-a.local
192.168.122.138 k8s-node-3-a.local
192.168.122.11  mirror.local
192.168.122.23  local-harbour-repo.net
```
disable swap
```bash
sudo vim /etc/fstab 
```
and comment out swap and disable in completely.
```bash
sudo swapoff -a
```
create repo certs folder.
```bash
sudo mkdir -p /etc/docker/certs.d/local-harbour-repo.net && cd /etc/docker/certs.d/local-harbour-repo.net
```
then return back to `/home`.
3 files should be added as in this scheme.
```text
/etc/docker/certs.d/
    └── yourdomain.com:port
       ├── yourdomain.com.cert  <-- Server certificate signed by CA
       ├── yourdomain.com.key   <-- Server key signed by CA
       └── ca.crt               <-- Certificate authority that signed the registry certificate
```
files 
```text
/etc/docker/certs.d
└── local-harbour-repo.net
    ├── ca.crt
    ├── local-harbour-repo.net.cert
    └── local-harbour-repo.net.key

1 directory, 3 files
```
next step is running install scripts
### <span style="color:blue">Setup scripts</span>
install docker
```bash
sudo sh 1-docker-install.sh
```
install docker tools
```bash
sudo sh 2-script.sh
```
verify
```bash
cri-dockerd --version
sudo docker system info
sudo systemctl status crio
systemctl status docker
```
install kubeadm
```bash
sudo sh 3-script.sh
```
### <span style="color:blue">Mirror and repo check</span>
```bash
sudo usermod -aG docker rouslan
```
verify connections with repo and mirror</br>
repo
```bash
docker login local-harbour-repo.net
```
mirror
```bash
curl http://mirror.local:5000/v2/_catalog
```
### <span style="color:blue">Preparation</span>
pull images
```bash
sudo kubeadm config images pull --cri-socket unix:///var/run/cri-dockerd.sock
```
## <span style="color:red">Master node</span>
### <span style="color:red">Init cluster</span>
setup cluster
```bash
sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --cri-socket unix:///var/run/cri-dockerd.sock \
  --control-plane-endpoint=k8s-master-a.local
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
#### <span style="color:red">Network setup</span>
use Weave
```bash
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```
## <span style="color:green">Slave node</span>
The connection script is generated run it on every node.
```bash
kubeadm join k8s-master-a.local:6443 --token wx3a9z.pgwh21tf2duo65oc \
	--discovery-token-ca-cert-hash sha256:9aa3f988a22a58d2197bb2bf4d2b131d0504a769d0a865b8f063ce5f8f22b1af \
	--cri-socket unix:///var/run/cri-dockerd.sock
```
the extra parameter is very important, don't forget `--cri-socket unix:///var/run/cri-dockerd.sock` it has to be added.

## Other steps

### swap
```bash
cat /proc/swaps
swapon -s
```

### config files
```bash
cat /root/.docker/config.json
``` 

```json
{
  "auths": {
    "local-harbour-repo.net": {
      "auth": "cm91c2xhbjo1MG05RmlEMw=="
    }
  }
}
```
```bash
echo -n 'cm91c2xhbjo1MG05RmlEMw==' | base64 --decode
```
output
```text
rouslan:50m9FiD3
```

### docker user permission
add to docker group.
```bash
usermod -aG docker $USER
```
and restart.
#### special situation
```bash
sudo groupadd docker
sudo groupadd docker
```
disk usage
```bash
df -h
```

```bash
sudo swapon --show
```