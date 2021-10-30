Instructions from last successful install

sudo usermod -aG docker rouslan


sudo systemctl enable kubelet

sudo kubeadm config images pull


sudo kubeadm init --control-plane-endpoint=k8s-ubuntu-master.localdomain --pod-network-cidr=192.168.0.0/16


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

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

kubeadm join k8s-ubuntu-master.localdomain:6443 --token 36p3kg.0mom61225yql3uj7 \
--discovery-token-ca-cert-hash sha256:4ffa74879bd6546e0a778082e66bab88070793ad2ca99b40c8c270696d60f3b2 \
--control-plane

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join k8s-ubuntu-master.localdomain:6443 --token 36p3kg.0mom61225yql3uj7 \
--discovery-token-ca-cert-hash sha256:4ffa74879bd6546e0a778082e66bab88070793ad2ca99b40c8c270696d60f3b2



rouslan@k8s-ubuntu-master:~$ mkdir -p $HOME/.kube
rouslan@k8s-ubuntu-master:~$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
[sudo] password for rouslan:
rouslan@k8s-ubuntu-master:~$ sudo chown $(id -u):$(id -g) $HOME/.kube/config

verify

rouslan@k8s-ubuntu-master:~$ kubectl get nodes
NAME                STATUS     ROLES                  AGE     VERSION
k8s-ubuntu-master   NotReady   control-plane,master   5m29s   v1.22.3



kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml



As sudo user

    1  cd scripts/
    2  ls
    3  sh docker-install 
    4  sudo usermod -aG docker $USER
    5  cd scripts/
    6  sh base-setup 
    7  sudo kubeadm config images pull
    8  sudo shutdown
    9  cat /etc/kubernetes/admin.conf
10  sudo kubeadm init --control-plane-endpoint=k8s-ubuntu-master.localdomain --pod-network-cidr=192.168.0.0/16
11  sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
12  sudo swapoff -a
13  sudo kubeadm init --control-plane-endpoint=k8s-ubuntu-master.localdomain --pod-network-cidr=192.168.0.0/16
14  export KUBECONFIG=/etc/kubernetes/admin.conf
15  kubectl get nodes
16  sudo kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
17  kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
18  kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml


separate terminal as user rouslan

20  mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
21  sudo chown $(id -u):$(id -g) $HOME/.kube/config
22  kubectl get nodes
23  watch kubectl get pods --all-namespaces
25  kubectl get nodes
26  history



kubeadm join k8s-ubuntu-master.localdomain:6443 --token wgg32f.5olw3m56nnliw6fg \
--discovery-token-ca-cert-hash sha256:cc9d9961aa299de9ba0cb6344d61163fa9aa5656202959e7f7c54e200ae17d73
