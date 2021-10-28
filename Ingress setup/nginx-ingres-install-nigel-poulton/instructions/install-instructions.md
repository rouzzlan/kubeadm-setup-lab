Instructions

Download the code files
```shell
git clone https://github.com/nigelpoulton/TheK8sBook.git
```

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/deploy/static/provider/cloud/deploy.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.4/deploy/static/provider/baremetal/deploy.yaml
kubectl get pods -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
```

```shell
kubect apply -f ig-class.yml
```


```shell
kubectl apply -f app.yml
```

```shell
kubectl apply -f ig-all.yml
```
Inspect ingres objects
```shell
kubectl get ing
```

```shell
kubectl describe ing  mcu-all
```


```shell
[rouslan@localhost ~]$ sudo firewall-cmd --get-active-zones
public
  interfaces: ens33
[rouslan@localhost ~]$ sudo firewall-cmd --zone=trusted --change-interface=ens33
success
[rouslan@localhost ~]$ sudo firewall-cmd --get-active-zones
trusted
  interfaces: ens33
```

```shell
   50  sudo firewall-cmd --state
   51  sudo systemctl start firewalld
   52  sudo firewall-cmd --state
   53  sudo systemctl enable firewalld
   54  sudo firewall-cmd --get-active-zones
   55  sudo firewall-cmd --zone=trusted --change-interface=ens33
   56  sudo firewall-cmd --get-active-zones

```
