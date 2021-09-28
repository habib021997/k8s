#!/bin/bash

#	Install Kubernetes Cluster using kubeadm on Ubuntu 20.04 LTS.


#	Disable Firewall
#ufw disable

#	Disable swap
#swapoff -a; sed -i '/swap/d' /etc/fstab

#	Update sysctl settings for Kubernetes networking
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

#	Install docker engine
#apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
#add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
#apt update
#apt install -y docker-ce=5:19.03.10~3-0~ubuntu-focal containerd.io


#	Kubernetes Setup
apt update && apt upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

#	Install Kubernetes components
apt update && apt install -y kubeadm=1.18.5-00 kubelet=1.18.5-00 kubectl=1.18.5-00

#	Initialize Kubernetes Cluster
kubeadm init --apiserver-advertise-address=192.168.2.174 --pod-network-cidr=10.244.0.0/16  --ignore-preflight-errors=all

#	Deploy a Flannel network
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

#	Deploy Calico network
#kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

#	Cluster join command
kubeadm token create --print-join-command

#	run kubectl commands as non-root user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config