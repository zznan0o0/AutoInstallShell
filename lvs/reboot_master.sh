# @reboot /bin/bash /root/lvs/run.sh >> /var/log/crontab.log 2>&1
# 主机
sleep 5
iface=enp0s3:0
vip=192.168.10.10
rs1=192.168.10.114
rs2=192.168.10.161
# 使用keepalived就不需要下面俩句
# ifconfig $iface $vip broadcast $vip netmask 255.255.255.255 up
# route add -host $vip dev $iface

# 启用系统的包转发功能
echo "1" >/proc/sys/net/ipv4/ip_forward
/sbin/sysctl -p

/sbin/ipvsadm -A -t $vip:80 -s wlc
/sbin/ipvsadm -a -t $vip:80 -r $rs1:80 -g -w 1
/sbin/ipvsadm -a -t $vip:80 -r $rs2:80 -g -w 1
