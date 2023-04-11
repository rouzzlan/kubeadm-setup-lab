### config in config.toml
file by default located in `/etc/containerd/config.toml`. and modify content.
```toml
version = 2

[plugins."io.containerd.grpc.v1.cri".registry]
   config_path = "/etc/containerd/certs.d"
```
### Mirror for docker hub (operational)
```bash
mkdir -p /etc/containerd/certs.d/docker.io && cd /etc/containerd/certs.d/docker.io
```
```text
$ tree /etc/containerd/certs.d
/etc/containerd/certs.d
└── docker.io
    └── hosts.toml
```
contents of `/etc/containerd/certs.d/docker.io/hosts.toml`-file
```toml
server = "https://registry-1.docker.io"

[host."http://mirror.local:5000"]
    capabilities = ["pull", "resolve"]
    skip_verify = true
```
verify
```bash
ctr images pull --hosts-dir "/etc/containerd/certs.d" docker.io/weaveworks/weave-kube:latest
```

### Simple (default) Host Config for Docker
Here is a simple example for a default registry hosts configuration. Set
`config_path = "/etc/containerd/certs.d"` in your config.toml for containerd.
Make a directory tree at the config path that includes `docker.io` as a directory
representing the host namespace to be configured. 
```bash
mkdir -p /etc/containerd/certs.d/docker.io && cd /etc/containerd/certs.d/docker.io
```

Then add a `hosts.toml` file
in the `docker.io` to configure the host namespace. It should look like this:

```
$ tree /etc/containerd/certs.d
/etc/containerd/certs.d
└── docker.io
    └── hosts.toml

$ cat /etc/containerd/certs.d/docker.io/hosts.toml
server = "https://docker.io"

[host."https://registry-1.docker.io"]
  capabilities = ["pull", "resolve"]
```

### Default mirror for all repo's
```bash
mkdir -p /etc/containerd/certs.d/_default && cd /etc/containerd/certs.d/_default
```
```text
$ tree /etc/containerd/certs.d
/etc/containerd/certs.d
└── _default
    └── hosts.toml
```
### setup for registry.k8s.io
```bash
mkdir -p /etc/containerd/certs.d/registry.k8s.io && cd /etc/containerd/certs.d/registry.k8s.io
```
```text
$ tree /etc/containerd/certs.d
/etc/containerd/certs.d
└── registry.k8s.io
    └── hosts.toml
```
contents of file `/etc/containerd/certs.d/_default/hosts.toml` located in `default` folder.
```toml
server = "https://registry.k8s.io"

[host."https://registry.k8s.io"]
  capabilities = ["pull", "resolve"]
```
containers used for kubeadm
```text
REPOSITORY                                TAG       IMAGE ID       CREATED         SIZE
registry.k8s.io/kube-apiserver            v1.26.2   63d3239c3c15   3 weeks ago     134MB
registry.k8s.io/kube-scheduler            v1.26.2   db8f409d9a5d   3 weeks ago     56.3MB
registry.k8s.io/kube-controller-manager   v1.26.2   240e201d5b0d   3 weeks ago     123MB
registry.k8s.io/kube-proxy                v1.26.2   6f64e7135a6e   3 weeks ago     65.6MB
registry.k8s.io/etcd                      3.5.6-0   fce326961ae2   3 months ago    299MB
registry.k8s.io/pause                     3.9       e6f181688397   5 months ago    744kB
registry.k8s.io/coredns/coredns           v1.9.3    5185b96f0bec   9 months ago    48.8MB
registry.k8s.io/pause                     3.6       6270bb605e12   19 months ago   683kB
weaveworks/weave-npc                      latest    690c3345cc9c   2 years ago     39.3MB
weaveworks/weave-kube                     latest    62fea85d6052   2 years ago     89MB
```
### private registry (operational)
```bash
mkdir -p /etc/containerd/certs.d/local-harbour-repo.net && cd /etc/containerd/certs.d/local-harbour-repo.net
```
`/etc/containerd/certs.d/local-harbour-repo.net/hosts.toml`
```toml
server = "https://local-harbour-repo.net"

[host."https://local-harbour-repo.net"]
    capabilities = ["pull", "resolve"]
    ca = ["/etc/containerd/certs.d/local-harbour-repo.net/ca.crt"]
```
contents of `ca.crt`. `/etc/containerd/certs.d/local-harbour-repo.net/ca.crt`
```text
-----BEGIN CERTIFICATE-----
MIIFzzCCA7egAwIBAgIUTe5NLivMHwHW+lM9zjPbveplwZswDQYJKoZIhvcNAQEN
BQAwdzELMAkGA1UEBhMCQkUxEDAOBgNVBAgMB0FudHdlcnAxEDAOBgNVBAcMB0Fu
dHdlcnAxEDAOBgNVBAoMB2V4YW1wbGUxETAPBgNVBAsMCFBlcnNvbmFsMR8wHQYD
VQQDDBZsb2NhbC1oYXJib3VyLXJlcG8ubmV0MB4XDTIzMDMxMDE3MTgyOFoXDTMz
MDMwNzE3MTgyOFowdzELMAkGA1UEBhMCQkUxEDAOBgNVBAgMB0FudHdlcnAxEDAO
BgNVBAcMB0FudHdlcnAxEDAOBgNVBAoMB2V4YW1wbGUxETAPBgNVBAsMCFBlcnNv
bmFsMR8wHQYDVQQDDBZsb2NhbC1oYXJib3VyLXJlcG8ubmV0MIICIjANBgkqhkiG
9w0BAQEFAAOCAg8AMIICCgKCAgEArrnNbiK75yViflR7sFyPwpHk8yMZyaN59u90
66R9alP5KLE42pYOPkmJZr3PNwl9dBh4cEPHNykNC8uEglb5ZMJkH4yfagRQaRka
A5CMNj5m1QtHxKs9g6P1QdWRKU0OULSxghDALuxgLlQQlm2Pnyzn0l/V+Qu0kYun
WT+AJCsPtZe7AMw0wTkhptGHYV9p7R+U1WgCZJnCDvowmBtDUPJQkN0WNaGBzy+A
bA+hY4rmcVy4Dt5u8+VKWFEggfDWhr9lpJ/xAl4BJ8Rf69/REbrhQA1m7a+cO+WL
4iKhtTD4u+Fuo6jG0q1mDDlYiVrliJBDs3ADJnFWp/3ukfY2t7FAXK3YLcIK3Cf3
r3aIo1A1PEe4BnnfVaeDebChUUvVveT7E/5Kq9/0VOuOiT30Uohrchtna9l5mFYS
2kvD9I9BJ7cLY+h8FXQWNbWAaJvtiKIgKKPW/9E3fMjyBCgEFTMmtoCzae4EXtHR
mpe4+ntie1wPUXFCtDxYLlwsOQsMFK/g0tdoif7mwiTgJZF6/3EATYxDNAdJnfWy
NnUZPgz5kySKjMEP1h6opwODZaqp1g2yZ8612AVNwNLtxUcf/0b83luJZT1LbgaW
bXlvAjrV4/OiTUcaU3PqSlefRnPmI0+NKNoO7fvnWMS1Goeqt6LImXkkY1MIpC+f
b9V/J2MCAwEAAaNTMFEwHQYDVR0OBBYEFAaDhw2uk7AyawbYJGur39mRsz4PMB8G
A1UdIwQYMBaAFAaDhw2uk7AyawbYJGur39mRsz4PMA8GA1UdEwEB/wQFMAMBAf8w
DQYJKoZIhvcNAQENBQADggIBAHx6Anc5pOZFJlraQDm43sQ/nrLY6UyRaB4TClyK
vCY3mT4CxIDD+D/qPq9msPmuTleo0wn9wFgV8cwH3o4u+eY6qLlIbLlVzVef0Vou
DP1vu8+UuHodRWEwtdqP3E4qUBpFPDUmjP6/ozYtJ7kff0rDQHMUguyAo9KdKSm3
iQPJyo4RYLQjEMY6kfnk0wLOD3gUOKfgJnE/L9bDP7Y1H/gGaRYit63v/MgMf4r2
Oa/qDyPBMiqU/IdqOYNDk5NHOuo1Wzn47tlX4acRAfJywxupcfLim+njb1L3pFsq
OXdxHVnFj3jJEKh6enxrhDLNCpvv0zcG7lM3Elbm0Ygfl6qkxRdAONz80cQGWTV6
qDsQm036gczw7lyIjbMpD4IRIH8dAcAn7P51WStBXgeCd/OUccYe546Gw6/eghSt
eMA70xANfLoXBbgkB7kDj5O9um21sfWNvmfw1dqjqds5TekTd2Q2oGvYfSgWWf0W
e7FiqbmC+Ejp7oFeKkGYDKRaxToecuSwZWlF1ECx4sNaFIakkLUQCc5c9FIc0FCO
DZ0bKc3+bcEbZeT+tKJ6b+kQ2DZBv/8re+EAgyM7siygV3sJE5Puy7iEgEXvkmAJ
jLm3L2st6MkxS7/Zn8Ne6+JsIMHmQHVHhiFB5BMzS9ycZOoZseNYqyi1p/2ehixi
nrnb
-----END CERTIFICATE-----
```
### pull image with crt
```bash
ctr images pull --hosts-dir "/etc/containerd/certs.d" local-harbour-repo.net/library/nginx:1.21.6-alpine
```

### Password config
encode username and password
```bash
echo -n 'rouslan:50m9FiD3' | base64
```
verify decode
```bash
echo -n 'cm91c2xhbjo1MG05RmlEMw==' | base64 --decode
```
config file (`/etc/containerd/config.toml`)
```toml
[plugins."io.containerd.grpc.v1.cri".registry.configs]
    [plugins."io.containerd.grpc.v1.cri".registry.configs."local-harbour-repo.net".auth]
        auth = "cm91c2xhbjo1MG05RmlEMw=="

[plugins."io.containerd.grpc.v1.cri".registry.mirrors]
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."local-harbour-repo.net"]
        endpoint = ["https://local-harbour-repo.net"]
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."local-harbour-repo.net"]
        endpoint = ["https://local-harbour-repo.net"]
```
reconfigure
```bash
sudo systemctl restart containerd
sudo containerd config dump
```

