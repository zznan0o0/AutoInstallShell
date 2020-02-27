#!/bin/bash
read -p "please input your ip: " IP
kubeadm init \
--apiserver-advertise-address=$IP \
--image-repository registry.aliyuncs.com/google_containers \
--pod-network-cidr=10.244.0.0/16