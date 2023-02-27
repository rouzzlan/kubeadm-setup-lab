## NGINX config
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
```
Open firewall ports
```bash
sudo firewall-cmd --permanent --zone=public --add-port=22010/tcp
sudo firewall-cmd --permanent --zone=public --add-port=22011/tcp
sudo firewall-cmd --permanent --zone=public --add-port=22012/tcp
sudo firewall-cmd --permanent --zone=public --add-port=22013/tcp
sudo firewall-cmd --reload
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
connect via ssh 
```bash
ssh rouslan@192.168.100.166 -p 22010
ssh rouslan@192.168.100.166 -p 22011
ssh rouslan@192.168.100.166 -p 22012
ssh rouslan@192.168.100.166 -p 22013
```