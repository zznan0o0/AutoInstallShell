# 主机
iface=ens33:0
vip=192.168.10.6
rs1=192.168.10.178
rs2=192.168.10.190
# 使用keepalived就不需要下面俩句
# ifconfig $iface $vip broadcast $vip netmask 255.255.255.255 up
# route add -host $vip dev $iface

# 启用系统的包转发功能
echo "1" >/proc/sys/net/ipv4/ip_forward 
sysctl -p

ipvsadm -A -t $vip:80 -s wlc
ipvsadm -a -t $vip:80 -r $rs1:80 -g -w 1
ipvsadm -a -t $vip:80 -r $rs2:80 -g -w 1



# 子机
iface=lo:0
vip=192.168.10.6
ifconfig $iface $vip broadcast $vip netmask 255.255.255.255 up
route add -host $vip dev $iface

# 关闭arp解析
# arp_announce ：定义不同级别：当ARP请求通过某个端口进来是否利用这个接口来回应。
#          0 -利用本地的任何地址，不管配置在哪个接口上去响应ARP请求；
#          1 - 避免使用另外一个接口上的mac地址去响应ARP请求；
#          2 - 尽可能使用能够匹配到ARP请求的最佳地址。

 

# arp_ignore：当ARP请求发过来后发现自己正是请求的地址是否响应；
#             0 - 利用本地的任何地址，不管配置在哪个接口上去响应ARP请求；
#             1 - 哪个接口上接受ARP请求，就从哪个端口上回应。

echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce 
echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce 

sysctl -p

# 清除主机
iface=ens33:0
vip=192.168.10.6
route del -host $vip dev $iface
ifconfig $iface down
ipvsadm -C

# 清除子机
iface=lo:0
vip=192.168.10.6
route del -host $vip $iface
ifconfig $iface down