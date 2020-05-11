#!/bin/bash
# 修改各自主机名
vim /etc/hostname

# swap 关闭
vim /etc/fstab
#注释
# /dev/fd0        /media/floppy0  auto    rw,user,noauto,exec,utf8 0       0

# 或者添加 --ignore-preflight-errors=Swap 参数

# read -p "please input your ip: " IP
# kubeadm init \
# --apiserver-advertise-address=$IP \
# --image-repository registry.aliyuncs.com/google_containers \
# --pod-network-cidr=10.244.0.0/16





kubeadm init \
  --apiserver-advertise-address=192.168.10.131 \
  --image-repository registry.aliyuncs.com/google_containers \
  --pod-network-cidr=10.244.0.0/16

# 配置 kubectl 工具
mkdir -p /root/.kube && \
cp /etc/kubernetes/admin.conf /root/.kube/config

kubectl get nodes

kubeadm join 192.168.10.131:6443 --token strr9l.re120ogvei3mz2eb \
    --discovery-token-ca-cert-hash sha256:51aa78c6b1bac52bee7a44db97b6858203d920b2bbafc5fddd667bbf69d596a9

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.12.0/Documentation/kube-flannel.yml


# 移除节点
kubectl drain <node name> --delete-local-data --force --ignore-daemonsets
kubectl delete node <node name>
kubeadm reset 