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


service redis restart

# sentinel
apt-get install redis-sentinel -y

# 全部配置
# https://www.cnblogs.com/linuxk/p/10718153.html#6、部署sentinel
vim /etc/redis/sentinel.conf

-----------------------
daemonize yes
pidfile "/var/run/sentinel/redis-sentinel.pid"
logfile "/var/log/redis/redis-sentinel.log"
port 26379
dir "/var/lib/redis"
sentinel myid 3ac9785721eb274906e2ed15945004e8e4ebdac5
sentinel monitor mymaster 192.168.10.64  6379 2
sentinel config-epoch mymaster 0
sentinel leader-epoch mymaster 0
sentinel current-epoch 0
protected-mode no

------------------------

redis-sentinel /etc/redis/sentinel.conf

redis-cli -p 26379
sentinel master mymaster
# 重置
sentinel reset myredis

---------------




tail -n 20 /var/log/sentinel.log