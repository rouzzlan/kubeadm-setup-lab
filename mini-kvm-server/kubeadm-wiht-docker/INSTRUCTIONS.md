# Setup instructions
### Color scheme
- <span style="color:blue">Master and Slave nodes</span>
- <span style="color:red">Master node</span>
- <span style="color:green">Slave node</span>

## <span style="color:blue">On all nodes</span>
### Hosts file
```bash
sudo vim /etc/hosts
```
add content
```text
192.168.122.130 k8s-master.local
192.168.122.131 k8s-node-1.local
192.168.122.132 k8s-node-2.local
192.168.122.133 k8s-node-3.local
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