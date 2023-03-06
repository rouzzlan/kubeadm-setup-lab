# Setup instructions
### Color scheme
- <span style="color:purple">KVM-Server</span>
- <span style="color:blue">Master and Slave nodes</span>
- <span style="color:red">Master node</span>
- <span style="color:green">Slave node</span>



## <span style="color:purple">Setup on the host</span>
#### NGINX config

```bash
sudo vim /etc/nginx/stream.conf.d/k8s.conf
```
add contents
```text
upstream k8s-master {
  server k8s-master.local:22;
}

server {
  listen 22010;
  proxy_pass k8s-master;
}


upstream k8s-node-1 {
  server k8s-node-1.local:22;
}

server {
  listen 22011;
  proxy_pass k8s-node-1;
}


upstream k8s-node-2 {
  server k8s-node-2.local:22;
}

server {
  listen 22012;
  proxy_pass k8s-node-2;
}


upstream k8s-node-3 {
  server k8s-node-3.local:22;
}

server {
  listen 22013;
  proxy_pass k8s-node-3;
}
#### Firewall settings
```
Open firewall ports
```bash
sudo firewall-cmd --permanent --zone=public --add-port=22010/tcp
sudo firewall-cmd --permanent --zone=public --add-port=22011/tcp
sudo firewall-cmd --permanent --zone=public --add-port=22012/tcp
sudo firewall-cmd --permanent --zone=public --add-port=22013/tcp
sudo firewall-cmd --reload
```
#### Edit the hosts file
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

reconfigure NGINX.
```bash
sudo nginx -T
sudo systemctl restart nginx
sudo systemctl status nginx
```

servers
disk setup
```text
vda    252:0    0   70G  0 disk 
├─vda1 252:1    0    1M  0 part 
├─vda2 252:2    0   20G  0 part /
├─vda3 252:3    0    1G  0 part /boot
├─vda4 252:4    0    3G  0 part /home
└─vda5 252:5    0   45G  0 part /var

```
## <span style="color:blue">nodes setup</span>
#### Guest servers access
the vms are accessable with following commands
```bash
ssh-copy-id 192.168.100.166 -p 22010
ssh-copy-id 192.168.100.166 -p 22011
ssh-copy-id 192.168.100.166 -p 22012
ssh-copy-id 192.168.100.166 -p 22013
```
#### administrative steps
##### install some base packages
```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install qemu-guest-agent -y
sudo systemctl start qemu-guest-agent.service
```
##### edit ssh settings
```sh
sudo vim /etc/ssh/sshd_config
```
Configure settings
```text
PasswordAuthentication no
PermitRootLogin no
ChallengeResponseAuthentication no
UsePAM no
```
save and reload
```sh
sudo systemctl restart ssh
```
##### Disable swap
edit config
```bash
sudo vim /etc/fstab
```
and comment
```text
#/swap.img      none    swap    sw      0       0
```
and disable swap
```bash
sudo swapoff -a
```
verify
```bash
sudo swapon --show
```
##### Hosts file
Edit the hosts file on every node of the cluster.
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
##### Last step
reboot the client.

## verification after base setup
Verify that the br_netfilter, overlay modules are loaded by running below instructions:
```bash
lsmod | grep br_netfilter
lsmod | grep overlay
```
Verify that the net.bridge.bridge-nf-call-iptables, net.bridge.bridge-nf-call-ip6tables, net.ipv4.ip_forward system variables are set to 1 in your sysctl config by running below instruction:
```bash
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
```


```bash
sudo kubeadm config images pull
```
init cluster
```bash
sudo kubeadm init --control-plane-endpoint=k8s-master.local
```
### Network setup
use Weave
```bash
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```
wait till all initialized
```text
root@k8s-master:/home/rouslan# kubectl get pods --all-namespaces
NAMESPACE     NAME                                 READY   STATUS              RESTARTS        AGE
kube-system   coredns-787d4945fb-879kg             1/1     Running             0               80s
kube-system   coredns-787d4945fb-pgsf4             0/1     ContainerCreating   0               80s
kube-system   etcd-k8s-master                      1/1     Running             1 (2m18s ago)   2m21s
kube-system   kube-apiserver-k8s-master            1/1     Running             1 (108s ago)    2m20s
kube-system   kube-controller-manager-k8s-master   1/1     Running             1 (2m18s ago)   43s
kube-system   kube-proxy-dnqgn                     1/1     Running             1 (61s ago)     80s
kube-system   kube-scheduler-k8s-master            1/1     Running             2 (54s ago)     54s
kube-system   weave-net-z4qgz                      2/2     Running             2 (18s ago)     36s
```
The node status should be rady now
```text
root@k8s-master:/home/rouslan# kubectl get nodes
NAME         STATUS   ROLES           AGE     VERSION
k8s-master   Ready    control-plane   2m30s   v1.26.2
```