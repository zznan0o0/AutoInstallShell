TOKEN="token-01"
CLUSTER_STATE="new"
NAME_1=machine-1
HOST_1=192.168.10.66

CLUSTER=${NAME_1}=http://${HOST_1}:2380

# For machine 1
THIS_NAME=${NAME_1}
THIS_IP=${HOST_1}
etcd --data-dir=data.etcd --name ${THIS_NAME} \
        --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://${THIS_IP}:2380 \
        --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://${THIS_IP}:2379,http:/127.0.0.1:2379 \
        --initial-cluster ${CLUSTER} \
        --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}


etcdctl --write-out table --endpoints "http://192.168.10.66:2379" member list
etcdctl --write-out table --endpoints "http://127.0.0.1:2379" member list



etcd --data-dir=data.etcd --name machine-1 \
        --initial-advertise-peer-urls http://192.168.10.66:2380 --listen-peer-urls http://192.168.10.66:2380 \
        --advertise-client-urls http://localhost:2379,http://127.0.0.1:2379,http://192.168.10.66:2379 --listen-client-urls http://0.0.0.0:2379 \
        --initial-cluster machine-1=http://192.168.10.66:2380 \
        --initial-cluster-state new --initial-cluster-token token-01

etcdctl --endpoints "http://192.168.10.66:2379" member add machine-2 --peer-urls=http://192.168.10.23:2380


# 返回值
ETCD_NAME="machine-2"
ETCD_INITIAL_CLUSTER="machine-2=http://192.168.10.23:2380,machine-1=http://192.168.10.66:2380"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.10.23:2380"
ETCD_INITIAL_CLUSTER_STATE="existing"


etcd --data-dir=data.etcd --name machine-2 \
        --initial-advertise-peer-urls http://192.168.10.23:2380 --listen-peer-urls http://192.168.10.23:2380 \
        --advertise-client-urls http://localhost:2379,http://127.0.0.1:2379,http://192.168.10.23:2379 --listen-client-urls http://0.0.0.0:2379 \
        --initial-cluster machine-2=http://192.168.10.23:2380,machine-1=http://192.168.10.66:2380 \
        --initial-cluster-state existing --initial-cluster-token token-01