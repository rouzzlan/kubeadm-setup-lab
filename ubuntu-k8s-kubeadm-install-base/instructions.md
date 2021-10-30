login as root on master node and run:
```shell
sudo su
sh docker-install 
sh base-setup
```
after installing required tools run init command:
```shell
kubeadm init
```
the output should end as follows:
```shell
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

kubeadm join 192.168.1.26:6443 --token wo5o45.zxssm5fyrz467kqh \
	--discovery-token-ca-cert-hash sha256:2d04c4b71e30caded42392603c23fa8a041c824a13731574fdc01bb626a2015c 
```
Open another shell and login as regular user on master node:
```shell
rouslan@k8s-ubuntu-master:~$ mkdir -p $HOME/.kube
rouslan@k8s-ubuntu-master:~$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
[sudo] password for rouslan: 
rouslan@k8s-ubuntu-master:~$ sudo chown $(id -u):$(id -g) $HOME/.kube/config

```
verify installations:
```shell
rouslan@k8s-ubuntu-master:~/.kube$ kubectl cluster-info
Kubernetes control plane is running at https://192.168.1.26:6443
CoreDNS is running at https://192.168.1.26:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
rouslan@k8s-ubuntu-master:~/.kube$ kubectl get nodes
NAME                STATUS     ROLES                  AGE     VERSION
k8s-ubuntu-master   NotReady   control-plane,master   4m45s   v1.22.3
```
Install networking tools:
```shell
rouslan@k8s-ubuntu-master:~/.kube$ kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```
verify installation:
```shell
rouslan@k8s-ubuntu-master:~/.kube$ kubectl get nodes
NAME                STATUS   ROLES                  AGE   VERSION
k8s-ubuntu-master   Ready    control-plane,master   12m   v1.22.3


rouslan@k8s-ubuntu-master:~/.kube$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                        READY   STATUS    RESTARTS      AGE
kube-system   coredns-78fcd69978-4wcl9                    1/1     Running   0             12m
kube-system   coredns-78fcd69978-8xtxk                    1/1     Running   0             12m
kube-system   etcd-k8s-ubuntu-master                      1/1     Running   0             12m
kube-system   kube-apiserver-k8s-ubuntu-master            1/1     Running   0             12m
kube-system   kube-controller-manager-k8s-ubuntu-master   1/1     Running   0             12m
kube-system   kube-proxy-57cwb                            1/1     Running   0             12m
kube-system   kube-scheduler-k8s-ubuntu-master            1/1     Running   0             12m
kube-system   weave-net-gptqp                             2/2     Running   1 (85s ago)   92s
```

command history:
```shell
root@k8s-ubuntu-master:/home/rouslan/scripts# history
    1  sh docker-install 
    2  sh base-setup 
    3  kubeadm init
    4  kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```
On child nodes run following command to connect to master:
```shell
kubeadm join 192.168.1.26:6443 --token wo5o45.zxssm5fyrz467kqh --discovery-token-ca-cert-hash sha256:2d04c4b71e30caded42392603c23fa8a041c824a13731574fdc01bb626a2015c 
```
