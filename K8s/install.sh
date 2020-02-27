#!/bin/bash
su -
echo  "deb https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial main" >> /etc/apt/sources.list
apt-get update && apt-get install -y apt-transport-https curl
apt-get install -y kubelet kubeadm kubectl --allow-unauthenticated