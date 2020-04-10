TOKEN="token-01"
CLUSTER_STATE="new"
NAME_1="machine-1"
NAME_2="machine-2"
NAME_3="machine-3"
NAME_4="machine-4"
HOST_1="192.168.10.66"
HOST_2="192.168.10.35"
HOST_3="192.168.10.190"
HOST_4="192.168.10.23"
CLUSTER="${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380"
CLUSTER_2="${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_4}=http://${HOST_4}:2380"


# For machine 4
THIS_NAME=${NAME_4}
THIS_IP=${HOST_4}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
	--initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${THIS_IP}:2380 \
	--advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${THIS_IP}:2379 \
	--initial-cluster ${CLUSTER_2} \
	--initial-cluster-state existing --initial-cluster-token ${TOKEN}




# 客户端
HOST_1="192.168.10.66"
HOST_2="192.168.10.35"
HOST_3="192.168.10.190"
ENDPOINTS=$HOST_1:2379,$HOST_2:2379,$HOST_3:2379

etcdctl --endpoints=$ENDPOINTS member list







