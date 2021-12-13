# Instructions
## base setup
create folder `scripts`, this is where the installation scripts will be held.
disable swap on every node.
```shell
sudo vim /etc/fstab 
```
and comment out the swap settings line
```shell
....
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/ubuntu-vg/ubuntu-lv during curtin installation
/dev/disk/by-id/dm-uuid-LVM-Ege7g168ZzN8iDTynXrwbp8A9amiHYSnA86EPqdD5g2w4ocp8AWVfRO17fXdGDop / ext4 defaults 0 1
# /boot was on /dev/sda2 during curtin installation
/dev/disk/by-uuid/f7f9f67c-8a42-4c38-b2e0-e2b689e5d2a5 /boot ext4 defaults 0 1
#/swap.img      none    swap    sw      0       0    <-------- COMMENT OUT THIS LINE

```
copy scripts `docker-install` and `base-setup` to the `scripts`-folder.
## docker setup (for all nodes)
login as root `sudo su`.
run the script as root.
```shell
sh docker-install
```
logout from root to regular user `rouslan` and run following command:
```shell
sudo usermod -aG docker $USER
```
reboot the system.
## base setup kubeadm tools
### run on all nodes
login as root `sudo su` and run `base-setup`-script:
```shell
cd scripts/
sh base-setup 
```
### after install on all nodes run on master node
```shell
sudo kubeadm config images pull
```
after this step a shutdown was performed, to take a snapshot of the VM.

## setting up the master node
login on the master node and init the node:
```shell
sudo kubeadm init --control-plane-endpoint=k8s-ubuntu-master.localdomain --pod-network-cidr=192.168.0.0/16
```
the output is then:
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

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join k8s-ubuntu-master.localdomain:6443 --token wgg32f.5olw3m56nnliw6fg \
	--discovery-token-ca-cert-hash sha256:cc9d9961aa299de9ba0cb6344d61163fa9aa5656202959e7f7c54e200ae17d73 \
	--control-plane 

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join k8s-ubuntu-master.localdomain:6443 --token wgg32f.5olw3m56nnliw6fg \
	--discovery-token-ca-cert-hash sha256:cc9d9961aa299de9ba0cb6344d61163fa9aa5656202959e7f7c54e200ae17d73 
root@k8s-ubuntu-master:/home/rouslan# export KUBECONFIG=/etc/kubernetes/admin.conf

```
login in separate terminal as user `rouslan` and run following commands:
```shell
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
after this run as super user `sudo su` the following command to verify:
```shell
kubectl get nodes
```
the output should be:
```shell
NAME                STATUS     ROLES                  AGE     VERSION
k8s-ubuntu-master   NotReady   control-plane,master   5m32s   v1.22.3
```
## Setting up network plugin Calico
in superuser shell `sudo su` run following commands
```shell
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml
```
after these instructions run following commands and verify that everything is running.
```shell
watch kubectl get pods --all-namespaces
```
after this the node should be ready:
```shell
kubectl get nodes
```
after this is the master node set up and ready
## Child nodes setup
run following command on every child node (the generated command will differ after every run).
```shell
kubeadm join k8s-ubuntu-master.localdomain:6443 --token wgg32f.5olw3m56nnliw6fg --discovery-token-ca-cert-hash sha256:cc9d9961aa299de9ba0cb6344d61163fa9aa5656202959e7f7c54e200ae17d73
```
## Credentials setup for dockerhub
if the k8s cluster is running on containerd (without Docker IO). Surround the password with single quotes.
```bash
kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=rouzzlan --docker-password='8Tw9E(/Z7mDE8i^jdEB8?[' --docker-email=rouslan_kh@hotmail.com
```
this gives following result:
```shell
secret/regcred created
```
source [URL](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/).
to verify configuration run following commands:
```shell
root@k8s-master-node:/home/rouslan/scripts# kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=rouzzlan --docker-password=8Tw9E(/Z7mDE8i^jdEB8?[ --docker-email=rouslan_kh@hotmail.com
bash: syntax error near unexpected token `(' <---- USE \' TO SURROND THE PASSWORD
root@k8s-master-node:/home/rouslan/scripts# kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=rouzzlan --docker-password='8Tw9E(/Z7mDE8i^jdEB8?[' --docker-email=rouslan_kh@hotmail.com
secret/regcred created
root@k8s-master-node:/home/rouslan/scripts# kubectl get secret regcred --output=yaml
apiVersion: v1
data:
  .dockerconfigjson: eyJhdXRocyI6eyJodHRwczovL2luZGV4LmRvY2tlci5pby92MS8iOnsidXNlcm5hbWUiOiJyb3V6emxhbiIsInBhc3N3b3JkIjoiOFR3OUUoL1o3bURFOGleamRFQjg/WyIsImVtYWlsIjoicm91c2xhbl9raEBob3RtYWlsLmNvbSIsImF1dGgiOiJjbTkxZW5wc1lXNDZPRlIzT1VVb0wxbzNiVVJGT0dsZWFtUkZRamcvV3c9PSJ9fX0=
kind: Secret
metadata:
  creationTimestamp: "2021-12-13T18:32:47Z"
  name: regcred
  namespace: default
  resourceVersion: "1456"
  uid: 67321030-8494-49ff-a0cb-671fb85e41db
type: kubernetes.io/dockerconfigjson
```
check the contents of the .dockerconfigjson:
```shell
root@k8s-master-node:/home/rouslan/scripts# kubectl get secret regcred --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode
{"auths":{"https://index.docker.io/v1/":{"username":"rouzzlan","password":"8Tw9E(/Z7mDE8i^jdEB8?[","email":"rouslan_kh@hotmail.com","auth":"cm91enpsYW46OFR3OUUoL1o3bURFOGleamRFQjg/Ww=="}}}
```