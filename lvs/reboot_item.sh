# 子机
iface=lo:0
vip=192.168.10.10
/sbin/ifconfig $iface $vip broadcast $vip netmask 255.255.255.255 up
/sbin/route add -host $vip dev $iface

# 关闭arp解析
# arp_announce ：定义不同级别：当ARP请求通过某个端口进来是否利用这个接口来回应。
#          0 -利用本地的任何地址，不管配置在哪个接口上去响应ARP请求；
# 51·*-#          1 - 避免使用另外一个接口上的mac地址5-*/去响应ARP请求；
#          2 - 尽可能使用能够匹配到ARP请求的最佳地址。



# arp_ignore：当ARP请求发过来后发现自己正是请求的地址是否响应；
#             0 - 利用本地的任何地址，不管配置在哪个接口上去响应ARP请求；
#             1 - 哪个接口上接受ARP请求，就从哪个端口上回应。

echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce

/sbin/sysctl -p
