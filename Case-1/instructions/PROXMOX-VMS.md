# Setup of Proxmox VM's
base setup and instructions of how the vm's should be configured before installation of k8s cluster.

## Create VM screen
Enable QEMU Agent in the `System`-section.</br>
In the `Disks`-section enable `Discard`-option and the right `Storage`-disk.</br>
In the `CPU`-section configure the right amount of cores (for example: 4 cores for master and 2 for child nodes)</br>
In the `Memory`-section configure the required memory for the VM.
Confirm and finish.

## Start the VM installation
Configure the `Network`-settings.</br>
For example:</br>
Master node</br>
Subnet mask: `192.168.0.0/16`</br>
IP: `192.168.1.10`</br>
In the `Profile`-section give the server the right server name. For master node `k8s-dev-master`.</br>
server will be restarted.

## Post install
### Log in to the server and perform update.
```sh
sudo apt-get update && sudo apt-get upgrade -y
```
### Install QEMU agent
Perform installation
```sh
sudo apt-get install qemu-guest-agent
```
verify status
```sh
systemctl status qemu-guest-agent.service
```
initial it is `inactive (dead)`, so start it up
```sh
sudo systemctl start qemu-guest-agent.service
```
then poweroff
```sh
sudo poweroff
```
### Modify Options
`Start on boot`-option set on `Yes`</br>
### Hardware Options
Set `CD/DVD Drive` on `Do not use any media`.</br>

### SSH configuration
Copy you key file to the server from your workstation
```sh
ssh-copy-id rouslan@192.168.2.10
```
then connect 
```sh
ssh rouslan@192.168.2.10
```
Then edit settings
```sh
sudo vim /etc/ssh/sshd_config
```
Configure settings
```text
PasswordAuthentication no
PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no
```
save and reload
```sh
sudo systemctl restart ssh
```
and power off if needed for backup
```sh
sudo poweroff
```