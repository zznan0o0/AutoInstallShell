mkdir -p /etc/redis/master
mkdir -p /etc/redis/cluster
mkdir -p /var/log/redis/master
mkdir -p /var/log/redis/cluster
mkdir -p /var/lib/redis/master
mkdir -p /var/lib/redis/cluster


vim /etc/redis/master/redis.conf

------
bind 0.0.0.0
port 7000
daemonize yes
pidfile "/root/redis/run/7000.pid"
logfile "/root/redis/log/7000.log"
dir "/root/redis/data/7000"
masterauth 123456
requirepass 123456
appendonly yes
cluster-enabled yes
cluster-config-file "/root/redis/conf/node_7000.conf"
cluster-node-timeout 15000
------


for v in {7000,7001,7002,7003,7004,7005};
do
  echo "bind 0.0.0.0
port $v
daemonize yes
pidfile /root/redis/run/$v.pid
logfile /root/redis/log/$v.log
dir /root/redis/data/$v
masterauth 123456
requirepass 123456
appendonly yes
cluster-enabled yes
cluster-config-file /root/redis/conf/node_$v.conf
cluster-node-timeout 15000" > /root/redis/conf/$v.conf;

done

for v in {7000,7001,7002,7003,7004,7005};
do
/usr/bin/redis-server "/root/redis/conf/$v.conf";
done


/usr/bin/redis-cli -a 123456 --cluster create 192.168.2.199:{7000,7001,7002,7003,7004,7005}  --cluster-replicas 1


# 集群方式登录
redis-cli -c -h 192.168.2.199 -p 7000 -a 123456

CLUSTER INFO # 集群状态
CLUSTER NODES # 集群节点