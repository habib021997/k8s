#!/bin/bash


kubeadm reset --force
sudo apt-get purge kubeadm kubectl kubelet kubernetes-cni kube* 



# on debian base
sudo apt-get autoremove

sudo rm -rf ~/.kube




rm -rf /etc/cni /etc/kubernetes /var/lib/dockershim /var/lib/etcd /var/lib/kubelet /var/run/kubernetes ~/.kube/*
rm /etc/sysctl.d/kubernetes.conf
iptables -F && iptables -X
iptables -t nat -F && iptables -t nat -X
iptables -t raw -F && iptables -t raw -X
iptables -t mangle -F && iptables -t mangle -X
systemctl restart docker