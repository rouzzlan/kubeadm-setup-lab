


configure `/etc/containerd/config.toml`

```toml
    [plugins."io.containerd.grpc.v1.cri".registry]
      config_path = "/etc/containerd/certs.d"

      [plugins."io.containerd.grpc.v1.cri".registry.auths]

      [plugins."io.containerd.grpc.v1.cri".registry.configs]
         [plugins."io.containerd.grpc.v1.cri".registry.configs."harbour.739.net".auth]
             auth = "cm91c2xhbjo1MG05RmlEMw=="
      [plugins."io.containerd.grpc.v1.cri".registry.headers]

      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
```
reload `containerd`
```bash
systemctl restart containerd
```
pull images
```bash
sudo kubeadm config images pull
```
init cluster
```bash
sudo kubeadm init \
  --control-plane-endpoint=k8s-d-master-node.739.net
```
add weave
```bash
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```
verify
```bash
kubectl get nodes
kubectl get pods --all-namespaces
```