# 开启核心转发
vim /etc/sysctl.conf
# net.ipv4.ip_forward=1
sysctl -p

port=80
vip=192.168.10.6
rs1=192.168.10.154
rs2=192.168.10.155
broadcast=192.168.10.255
mask=255.255.255.0
iface=ens33:0

ifconfig $iface $vip netmask $mask broadcast $broadcast up

ipvsadm -A -t ${vip}:${port} -s wlc
ipvsadm -a -t ${vip}:${port} -r ${rs1} -g -w 1
ipvsadm -a -t ${vip}:${port} -r ${rs2} -g -w 1



#######################################
# 主机
iface=ens33:0
vip=192.168.10.6
rs1=192.168.10.154
rs2=192.168.10.155
ifconfig $iface $vip broadcast $vip netmask 255.255.255.255 up
# route add -host $vip dev $iface

ipvsadm -A -t $vip:80 -s wlc
ipvsadm -a -t $vip:80 -r $rs1:80 -g -w 2
ipvsadm -a -t $vip:80 -r $rs2:80 -g -w 1

# 子机
iface=lo:0
vip=192.168.10.6
ifconfig $iface $vip broadcast $vip netmask 255.255.255.255 up
# route add -host $vip $iface


# 清除
# 主机
iface=ens33:0
vip=192.168.10.6
# route del -host $vip dev $iface
ifconfig $iface down
ipvsadm -C

# 子机
iface=lo:0
vip=192.168.10.6
# route del -host $vip $iface
ifconfig $iface down




