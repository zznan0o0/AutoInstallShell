# slave

# master
vim /etc/redis/redis.conf
------------
bind 0.0.0.0
requirepass "123456"
------------

# backup

vim /etc/redis/redis.conf
------------
bind 0.0.0.0
requirepass "123456"
# 指定主服务器，注意：有关slaveof的配置只是配置从服务器，主服务器不需要配置
slaveof 192.168.10.64 6379
# 主服务器密码，注意：有关slaveof的配置只是配置从服务器，主服务器不需要配置
masterauth 123456
------------


service redis-server restart

# redis登录
redis-cli
auth 123456

info replication

# sentinel
apt-get install redis-sentinel -y

# 全部配置
# https://www.cnblogs.com/linuxk/p/10718153.html#6、部署sentinel
vim /etc/redis/sentinel.conf


-----------------------
port 26379
daemonize yes
pidfile /var/run/redis/redis-sentinel.pid
logfile /var/log/redis/redis-sentinel.log
dir /var/lib/redis
sentinel monitor mymaster 192.168.10.64 6379 2
sentinel down-after-milliseconds mymaster 30000
sentinel parallel-syncs mymaster 1
sentinel failover-timeout mymaster 180000
sentinel auth-pass mymaster 123456
sentinel deny-scripts-reconfig yes
sentinel client-reconfig-script mymaster /var/redis/reconfig.sh

------------------------


redis-sentinel /etc/redis/sentinel.conf

cat /var/log/redis/redis-sentinel.log


redis-cli -p 26379
sentinel master mymaster
# 重置
killall -9 redis-sentinel
sentinel reset myredis

---------------




tail -n 20 /var/log/sentinel.log


# 一下非必要只是维护习惯选自己习惯的就好
------------------


echo '[Unit]
Description=redis-sentinel
After=redis-ms.service

[Service]
Type=forking
Restart=always
ExecStart=/usr/bin/redis-sentinel /etc/redis/sentinel.conf
PIDFile=/var/run/redis/redis-sentinel.pid

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/redis-sentinel.service


# 重启后添加虚拟ip
vim /root/sh/reboot_vip.sh
```
#/bin/bash
/bin/sleep 10
LOCAL_IP=192.168.2.203
VIP=192.168.2.250
MASTER_IP=`/usr/bin/redis-cli  -p 26379  sentinel master mymaster | awk '{if(NR==4){print}}'`

if [ ${LOCAL_IP} = ${MASTER_IP} ]; then
    /sbin/ip addr add $VIP/24 dev enp0s3
fi
```

# 不支持sentinelredis用vip
# 支持sentinel用三个ip
# 也可读写分离nginxip+vip