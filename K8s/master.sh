#!/bin/bash
# 修改各自主机名
vim /etc/hostname

# swap 关闭
vim /etc/fstab
#注释第二行
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

# 直接访问被拒
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# 直接浏览器访问复制内容到新建flannel.yaml文件中
kubectl apply -f ./flannel.yaml


# 移除节点
kubectl drain <node name> --delete-local-data --force --ignore-daemonsets
kubectl delete node <node name>
kubeadm reset 


# 添加部署管理 deployment 
kubectl create -f Deployment.yaml
# 查看是否部署 如果状态ImagePullBackOff 那需要配置secret拉取私有镜像
kubectl get pods -o wide

# 添加服务管理 service统一ip
kubectl create -f Service.yaml
# 查看结果
kubectl get services

# 删除部署与服务
kubectl delete deployments/nginx services/my-service