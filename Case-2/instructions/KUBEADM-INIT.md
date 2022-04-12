# Init cluster
All these instructions should run as super user.
```sh
sudo su
```
## Init master node
Run following command on `Master`-node:
```sh
sudo kubeadm init
```
as output to confirm that installation was successful you will see:
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

  kubeadm join pve2-k8s-dev-master.localdomain:6443 --token ete6l9.8bbedbyxr8cjooun \
	--discovery-token-ca-cert-hash sha256:2a53861dd9d86135454127faecea7e14de8891cc4286d2e70b8c4c944165f542 \
	--control-plane 

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join pve2-k8s-dev-master.localdomain:6443 --token ete6l9.8bbedbyxr8cjooun \
	--discovery-token-ca-cert-hash sha256:2a53861dd9d86135454127faecea7e14de8891cc4286d2e70b8c4c944165f542
```
## non root user acces
run following script: [kubectl-user-access](kubectl-init/kubectl-user-access)</br>
test with following command:
```sh
kubectl get nodes
```
output:
```shell
NAME             STATUS     ROLES                  AGE    VERSION
k8s-dev-master   NotReady   control-plane,master   4m6s   v1.23.5
```
## Master node setup (continuation)
you should be still in `sudo su`-mode.
run 
```sh
export KUBECONFIG=/etc/kubernetes/admin.conf
```
verify master node status:
```shell
root@k8s-dev-master:/home/rouslan/scripts# kubectl get nodes
NAME             STATUS     ROLES                  AGE     VERSION
k8s-dev-master   NotReady   control-plane,master   7m59s   v1.23.5
```
### configure weave networking plugin
run this command
```shell
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```
verify state of master node:
```shell
root@k8s-dev-master:/home/rouslan/scripts# kubectl get nodes
NAME             STATUS   ROLES                  AGE     VERSION
k8s-dev-master   Ready    control-plane,master   9m42s   v1.23.5
```
You are now ready with the master node.

## separate window (not required)

watch all pods in separate window
```sh
watch kubectl get pods --all-namespaces
```
will give following output when ready
```shell
NAMESPACE          NAME                                       READY   STATUS    RESTARTS   AGE
calico-apiserver   calico-apiserver-68fc6cfb46-88rlt          1/1     Running   0          41s
calico-apiserver   calico-apiserver-68fc6cfb46-wn57s          1/1     Running   0          41s
calico-system      calico-kube-controllers-67f85d7449-l62mr   1/1     Running   0          102s
calico-system      calico-node-8qpzn                          1/1     Running   0          102s
calico-system      calico-typha-6bdc8b9f4d-ncxtr              1/1     Running   0          102s
kube-system        coredns-64897985d-p2bsp                    1/1     Running   0          10m
kube-system        coredns-64897985d-w6crb                    1/1     Running   0          10m
kube-system        etcd-k8s-dev-master                        1/1     Running   0          10m
kube-system        kube-apiserver-k8s-dev-master              1/1     Running   0          10m
kube-system        kube-controller-manager-k8s-dev-master     1/1     Running   0          10m
kube-system        kube-proxy-5l5gj                           1/1     Running   0          10m
kube-system        kube-scheduler-k8s-dev-master              1/1     Running   0          10m
tigera-operator    tigera-operator-b876f5799-wrdkp            1/1     Running   0          114s
```

## kubectl child nodes
run on every child node this command in `sudo su`-mode:
```sh
kubeadm join pve2-k8s-dev-master.localdomain:6443 --token ete6l9.8bbedbyxr8cjooun \
	--discovery-token-ca-cert-hash sha256:2a53861dd9d86135454127faecea7e14de8891cc4286d2e70b8c4c944165f542 
```
when ready it should give following output.
```shell
W0320 18:59:16.159318    9315 utils.go:69] The recommended value for "resolvConf" in "KubeletConfiguration" is: /run/systemd/resolve/resolv.conf; the provided value is: /run/systemd/resolve/resolv.conf
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```

on the master node you can verify finished state:
```shell
rouslan@k8s-dev-master:~$ kubectl get nodes
NAME             STATUS   ROLES                  AGE   VERSION
k8s-dev-master   Ready    control-plane,master   83m   v1.23.5
k8s-dev-node-1   Ready    <none>                 68m   v1.23.5
k8s-dev-node-2   Ready    <none>                 67m   v1.23.5
k8s-dev-node-3   Ready    <none>                 67m   v1.23.5
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

## Get cluster config
get the `config` file from `.kube` directory. for example from `/home/rouslan/.kube`.