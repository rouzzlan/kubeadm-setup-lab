## Master node
```shell
[rouslan@k8s-master .kube]$ history
    1  sudo yum update
    2  whereis ssh
    3  whereis vim
    4  sudo shutdown -h now
    5  ip a
    6  systemctl restart network
    7  sudo shutdown -h now
    8  ls
    9  git clone https://github.com/sandervanvugt/cka/blob/master/setup-docker.sh
   10  sudo yum install git
   11  git clone https://github.com/sandervanvugt/cka/blob/master/setup-docker.sh
   12  ls
   13  git clone https://github.com/sandervanvugt/cka.git
   14  ls
   15  cd cka/
   16  ls
   17  sudo su
   18  mkdir -p $HOME/.kube
   19  cd .kube/
   20  ls
   21  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
   22  ls
   23  sudo chown $(id -u):$(id -g) $HOME/.kube/config
   24  ls
   25  kubectl cluster-info
   26  kubectl get nodes
   27  $ kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
   28  kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
   29  kubectl get pods --all-namespaces
   30  kubectl get nodes
   31  history
   32  cd ~
   33  cd .kube/
   34  pwd
   35  history

```
