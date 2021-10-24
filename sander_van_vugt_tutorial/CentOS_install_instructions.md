# Instructions
Installation instructions followed from <b>Certified Kubernetes Administrator (CKA)</b> chapter 3, made by Sander van Vugt.
## Installation steps
- Install docker + other utilities and disable firewall.
- Install kubeadm tools
- Configure master node
- connect nodes to master node

## Docker installation
run the commands in the [docker-setup.sh](docker-setup) as root user, so do the `sudo su`.
commands performed on mater node:
```shell
[root@k8s-master cka]# history
    1  ./setup-docker.sh 
    2  docker version
    3  yum install -y vim yum-utils device-mapper-persistent-data lvm2
    4  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    5  yum install -y docker-ce
    6  docker version
    7  mkdir /etc/docker
    8  cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

    9  mkdir -p /etc/systemd/system/docker.service.d
   10  systemctl daemon-reload
   11  systemctl restart docker
   12  systemctl enable docker
   13  systemctl disable --now firewalld
   14  docker version
   15  history
[root@k8s-master cka]# 
```
<b>Notes:</b>
command 1 did not work the script did not install docker so command on 2 did not work ether.
From 3 to 14 the commands were inserted manually.
If all succeeds after you run command:
```bash
sudo docker version
```
you should get output:
```shell
[rouslan@k8s-master .kube]$ sudo docker version
[sudo] password for rouslan: 
Client: Docker Engine - Community
 Version:           20.10.9
 API version:       1.41
 Go version:        go1.16.8
 Git commit:        c2ea9bc
 Built:             Mon Oct  4 16:08:14 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.9
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.16.8
  Git commit:       79ea9d3
  Built:            Mon Oct  4 16:06:37 2021
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.4.11
  GitCommit:        5b46e404f6b9f661a205e28d59c982d3634148f8
 runc:
  Version:          1.0.2
  GitCommit:        v1.0.2-0-g52b36a2
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```
## Install kubeadm tools
next perform installation of [setup-kubeadm](setup-kubeadm)-script as super user (`sudo su`).
Installation history on master node:
```shell
29  cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

   30  setenforce 0
   31  sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
   32  sed -i 's/^\/dev\/mapper\/centos-swap/#\/dev\/mapper\/centos-swap/' /etc/fstab
   33  swapoff /dev/mapper/centos-swap
   34  yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
   35  systemctl enable --now kubelet
   36  cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

   37  sysctl --system
   38  history
```

## Perform kubectl init
### init on master node
commands:
```shell
[root@k8s-master rouslan]# kubeadm init
[init] Using Kubernetes version: v1.22.2
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [k8s-master.localdomain kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.1.20]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [k8s-master.localdomain localhost] and IPs [192.168.1.20 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [k8s-master.localdomain localhost] and IPs [192.168.1.20 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 5.004146 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.22" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node k8s-master.localdomain as control-plane by adding the labels: [node-role.kubernetes.io/master(deprecated) node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node k8s-master.localdomain as control-plane by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[bootstrap-token] Using token: oepuu4.4gawgiphpvmxisc6
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.20:6443 --token oepuu4.4gawgiphpvmxisc6 \
	--discovery-token-ca-cert-hash sha256:31a2f9faefb52a3e7d5e08fe622842b6e66465c8c29022d0b40cb75e2aed0c30 
[root@k8s-master rouslan]# su - rouslan 
Last login: sam. oct. 23 13:58:41 EDT 2021 from workstation.localdomain on pts/0
[rouslan@k8s-master ~]$ mkdir -p $HOME/.kube
[rouslan@k8s-master ~]$ cd .kube/
[rouslan@k8s-master .kube]$ ls
[rouslan@k8s-master .kube]$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
[sudo] password for rouslan: 
[rouslan@k8s-master .kube]$ ls
config
[rouslan@k8s-master .kube]$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
[rouslan@k8s-master .kube]$ ls
config
[rouslan@k8s-master .kube]$ kubectl cluster-info
Kubernetes control plane is running at https://192.168.1.20:6443
CoreDNS is running at https://192.168.1.20:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```
Install weave plugin on master node:
```shell
[rouslan@k8s-master .kube]$ kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
serviceaccount/weave-net created
clusterrole.rbac.authorization.k8s.io/weave-net created
clusterrolebinding.rbac.authorization.k8s.io/weave-net created
role.rbac.authorization.k8s.io/weave-net created
rolebinding.rbac.authorization.k8s.io/weave-net created
daemonset.apps/weave-net created

```
verify whether weave is working:
```shell
[rouslan@k8s-master .kube]$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                             READY   STATUS    RESTARTS      AGE
kube-system   coredns-78fcd69978-5c7jm                         1/1     Running   0             21m
kube-system   coredns-78fcd69978-ppkdc                         1/1     Running   0             21m
kube-system   etcd-k8s-master.localdomain                      1/1     Running   0             21m
kube-system   kube-apiserver-k8s-master.localdomain            1/1     Running   0             21m
kube-system   kube-controller-manager-k8s-master.localdomain   1/1     Running   0             21m
kube-system   kube-proxy-mn6sc                                 1/1     Running   0             21m
kube-system   kube-scheduler-k8s-master.localdomain            1/1     Running   0             21m
kube-system   weave-net-rh5dx                                  2/2     Running   1 (90s ago)   97s
[rouslan@k8s-master .kube]$ kubectl get nodes

```
### join on child node 1
shell history:
```shell
[root@k8s-node-1 rouslan]# kubeadm join 192.168.1.20:6443 --token oepuu4.4gawgiphpvmxisc6 \
> ^C
[root@k8s-node-1 rouslan]# kubeadm join 192.168.1.20:6443 --token oepuu4.4gawgiphpvmxisc6 --discovery-token-ca-cert-hash sha256:31a2f9faefb52a3e7d5e08fe622842b6e66465c8c29022d0b40cb75e2aed0c30 
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

```
### verify connection with child nodes
after connecting the childnodes check whether the connection is established on master node:
```shell
[rouslan@k8s-master .kube]$ kubectl get nodes
NAME                     STATUS   ROLES                  AGE     VERSION
k8s-master.localdomain   Ready    control-plane,master   28m     v1.22.2
k8s-node-1.localdomain   Ready    <none>                 3m51s   v1.22.2
k8s-node-2.localdomain   Ready    <none>                 3m5s    v1.22.2
```
## Connecting client to the cluster
bulk commands on client (Ubuntu).
```shell
rouslan@k8s-client:~/.kube$ history
    1  sudo apt-get update && sudo apt-get upgrade -y
    2  sudo hostnamectl --static set-hostname k8s-client
    3  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    4  sudo snap install curl
    5  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    6  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    7  kubectl version --client
    8  mkdir ~/.kube
    9  cd .kube/
   10  ls
   11  scp root@k8s-master.localdomain:/home/rouslan/.kube/config ~/.kube/config2
   12  ls
   13  vim config2 
   14  sudo apt install vim
   15  vim config2 
   16  export KUBECONFIG=~/.kube/config2
   17  kubectl get nodes

```
Ignore lines: 1, 2, 3, 10, 12
