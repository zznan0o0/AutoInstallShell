# 主机
iface=enp0s3:0
vip=192.168.2.39
rs1=192.168.2.22
rs2=192.168.2.27
rs3=192.168.2.40
# 使用keepalived就不需要下面俩句
# ifconfig $iface $vip broadcast $vip netmask 255.255.255.255 up
# route add -host $vip dev $iface

# 启用系统的包转发功能
echo "1" >/proc/sys/net/ipv4/ip_forward
/sbin/sysctl -p

/sbin/ipvsadm -A -t $vip:80 -s wlc
/sbin/ipvsadm -a -t $vip:80 -r $rs1:80 -g -w 1
/sbin/ipvsadm -a -t $vip:80 -r $rs2:80 -g -w 1
/sbin/ipvsadm -a -t $vip:80 -r $rs3:80 -g -w 1

/sbin/ipvsadm -A -t $vip:8080 -s wlc
/sbin/ipvsadm -a -t $vip:8080 -r $rs1:8080 -g -w 1
/sbin/ipvsadm -a -t $vip:8080 -r $rs2:8080 -g -w 1
/sbin/ipvsadm -a -t $vip:8080 -r $rs3:8080 -g -w 1

/sbin/ipvsadm -A -t $vip:8090 -s wlc
/sbin/ipvsadm -a -t $vip:8090 -r $rs1:8090 -g -w 1
/sbin/ipvsadm -a -t $vip:8090 -r $rs2:8090 -g -w 1
/sbin/ipvsadm -a -t $vip:8090 -r $rs3:8090 -g -w 1

/sbin/ipvsadm -A -t $vip:8070 -s wlc
/sbin/ipvsadm -a -t $vip:8070 -r $rs1:8070 -g -w 1
/sbin/ipvsadm -a -t $vip:8070 -r $rs2:8070 -g -w 1
/sbin/ipvsadm -a -t $vip:8070 -r $rs3:8070 -g -w 1

/sbin/ipvsadm -A -t $vip:8081 -s wlc
/sbin/ipvsadm -a -t $vip:8081 -r $rs1:8081 -g -w 1
/sbin/ipvsadm -a -t $vip:8081 -r $rs2:8081 -g -w 1
/sbin/ipvsadm -a -t $vip:8081 -r $rs3:8081 -g -w 1

/sbin/ipvsadm -A -t $vip:8091 -s wlc
/sbin/ipvsadm -a -t $vip:8091 -r $rs1:8091 -g -w 1
/sbin/ipvsadm -a -t $vip:8091 -r $rs2:8091 -g -w 1
/sbin/ipvsadm -a -t $vip:8091 -r $rs3:8091 -g -w 1


