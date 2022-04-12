# K8s cluster setup
This document describes how a k8s cluster is set up from the ground of.

## Steps
[VM's setup in Proxmox](#proxmox-vm)</br>
[VM setup for kubeadm](#vm-setup-for-kubeadm)</br>
[Init kubeadm cluster](#init-kubeadm-cluster)</br>

### Proxmox VM
The OS for the VM's will be Ubuntu 20.04 LTS. In the following [document](instructions/PROXMOX-VMS.md) will be described how this should be setup.

### VM setup for kubeadm
Here you find instructions needed to install `containerd` and `kubeadm`.
[Document](instructions/BASE-SETUP.md)</br>

### Init kubeadm cluster
Initialization instructions to init cluster (master and child nodes).
[Document](instructions/KUBEADM-INIT.md)</br>