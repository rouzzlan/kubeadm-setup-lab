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