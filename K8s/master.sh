#!/bin/bash
read -p "please input your ip: " IP
kubeadm init \
--apiserver-advertise-address=$IP \
--image-repository registry.aliyuncs.com/google_containers \
--pod-network-cidr=10.244.0.0/16



kubeadm init \
--apiserver-advertise-address=192.168.10.241 \
--image-repository registry.aliyuncs.com/google_containers \
--pod-network-cidr=10.244.0.0/16