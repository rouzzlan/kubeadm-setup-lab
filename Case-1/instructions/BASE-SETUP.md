# Base setup instructions
Description of what needs to be installed and configured before start of forming a kubeadm cluster.
## Add folder script and disable swap
create folder `scripts`, this is where the installation scripts will be held.
disable swap on every node.
```shell
sudo vim /etc/fstab 
```
temporary disable of swap is not enough
```sh
sudo swapoff -a 
```
## Run script to install containerd
Go to the `scripts`-folder that you created in user home directory.
```sh
sudo su
```
Run following script as root --> [containerd-install](base-setup/containerd-install).</br>
After successful install run [kubeadm-install](base-setup/kubeadm-install) installation script as root.</br>
run following command to pull config images
```sh
kubeadm config images pull
```

### DNS on raspberry pi
create name for specific IP's, for example:
`pve2-dev-master.localdomain` ---> `192.168.2.10`</br>
In this project it is
`pve2-k8s-dev-master.localdomain` ---> `192.168.2.10`</br.
