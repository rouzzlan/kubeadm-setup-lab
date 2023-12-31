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
# k8s cluster b
192.168.122.90  k8s-b-master.local
192.168.122.91  k8s-b-node-1.local
192.168.122.92  k8s-b-node-2.local
192.168.122.93  k8s-b-node-3.local

```
### <span style="color:purple">configure NGINX</span>
```bash
sudo vim /etc/nginx/stream.conf.d/k8s-b.conf
```

```text
upstream k8s-b-master {
  server k8s-b-master.local:22;
}

server {
  listen 22030;
  proxy_pass k8s-b-master;
}


upstream k8s-b-node-1 {
  server k8s-b-node-1.local:22;
}

server {
  listen 22031;
  proxy_pass k8s-b-node-1;
}


upstream k8s-b-node-2 {
  server k8s-b-node-2.local:22;
}

server {
  listen 22032;
  proxy_pass k8s-b-node-2;
}


upstream k8s-b-node-3 {
  server k8s-b-node-3.local:22;
}

server {
  listen 22033;
  proxy_pass k8s-b-node-3;
}
```
open ports
```bash
sudo firewall-cmd --add-port=22030-22033/tcp --permanent
sudo firewall-cmd --reload
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
sudo apt-get install qemu-guest-agent -y && sudo systemctl start qemu-guest-agent.service
```
### <span style="color:blue">Hosts file</span>
```bash
sudo vim /etc/hosts
```
add content
```text
192.168.122.90  k8s-b-master.local
192.168.122.91  k8s-b-node-1.local
192.168.122.92  k8s-b-node-2.local
192.168.122.93  k8s-b-node-3.local
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
next step is running install scripts
### <span style="color:blue">Setup scripts</span>
install containerd
```bash
sudo sh 1-containerd-install.sh
```
configure repo and mirror</br>
[instructions](conf/setup.md)</br>
install kubeadm
```bash
sudo sh 2-kubeadm-install.sh
```
configure network
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
sudo kubeadm config images pull --cri-socket unix:///var/run/containerd/containerd.sock
```
## <span style="color:red">Master node</span>
### <span style="color:red">Init cluster</span>
setup cluster
```bash
sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --cri-socket unix:///var/run/containerd/containerd.sock \
  --control-plane-endpoint=k8s-b-master.local
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
kubeadm join k8s-b-master.local:6443 --token p006hk.aqz16aws6nlkg52m \
	--discovery-token-ca-cert-hash sha256:02261481cbf6b35244fdbff4cfd9c5a48340f4937362fec4b4ecedeac8d5e281
```
the extra parameter is very important, don't forget `--cri-socket unix:///var/run/containerd/containerd.sock` it has to be added.

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

## <span style="color:blue">pod deployment test</span>
tested wit `nginx:1.21.6-alpine`-image that was stored locally.
tagged and pushed the image
```bash
docker tag nginx:1.21.6-alpine local-harbour-repo.net/library/nginx:1.21.6-alpine
docker push local-harbour-repo.net/library/nginx:1.21.6-alpine
```
save contents of the yaml file to `pod.yaml`.
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
    - name: nginx
      image: local-harbour-repo.net/library/nginx:1.21.6-alpine
```
on the master node run
```bash
kubectl apply -f pod.yaml
```
verify with 
```bash
kubectl describe pod nginx
kubectl describe pod nginx
```

## Notes

```text
/etc/containerd/certs.d/
├── _default
│   └── hosts.toml
├── docker.io
│   └── hosts.toml
├── harbour.739.net
│   ├── ca.crt
│   └── hosts.toml
└── registry.k8s.io
    └── hosts.toml

```