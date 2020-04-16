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
netmask=255.255.255.0
broadcast=192.168.10.255
rs1=192.168.10.154
rs2=192.168.10.155


ifconfig $iface $vip broadcast $broadcast netmask $netmask up
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







#####################
iface=ens33:0
vip=192.168.10.6
rs1=192.168.10.178
rs2=192.168.10.190
ifconfig $iface $vip broadcast $vip netmask 255.255.255.255 up
# route add -host $vip dev $iface

ipvsadm -A -t $vip:80 -s rr
ipvsadm -a -t $vip:80 -r $rs1:80 -g 
ipvsadm -a -t $vip:80 -r $rs2:80 -g 


###############

ifconfig ens33:0 192.168.10.6 broadcast 192.168.10.6 netmask 255.255.255.255 up

route add -host 192.168.10.6 dev ens33:0
echo "1" >/proc/sys/net/ipv4/ip_forward 
sysctl -p

ipvsadm -A -t 192.168.10.6:80 -s rr


ipvsadm -a -t 192.168.10.6:80 -r 192.168.10.178:80 -g
ipvsadm -a -t 192.168.10.6:80 -r 192.168.10.190:80 -g




ifconfig lo:0 192.168.10.6 broadcast 192.168.10.6 netmask 255.255.255.255 up
route add -host 192.168.10.6 dev lo:0

echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore

echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce 

echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore

echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce 

sysctl -p


#############


! Configuration File for keepalived

global_defs {
   #notification_email {
   #  acassen@firewall.loc
   #  failover@firewall.loc
   #  sysadmin@firewall.loc
   #}
   #notification_email_from Alexandre.Cassen@firewall.loc
   #smtp_server 192.168.200.1
   #smtp_connect_timeout 30
   router_id LVS_DEVEL
}

vrrp_instance VI_1 {
    #141节点设置为MASTER，142或者还有其他的节点设置为BACKUP
    #还记得我们前面文章讲到的无抢占设置吗？这里也可以用哦。
    state MASTER
    #网络适配器名称
    interface ens33
    virtual_router_id 51
    #所有的SLAVE节点的优先级都要比这个设置值低
    priority 120
    advert_int 1
    #真实ip，142要改成相应的lvs节点真实ip
    mcast_src_ip=192.168.10.80
    authentication {
        auth_type PASS
        auth_pass 123456
    }
    #虚拟/浮动IP
    virtual_ipaddress {
        192.168.10.6
    }
}

virtual_server 192.168.10.6 80 {
    #健康时间检查，单位秒
    delay_loop 6
    #负载均衡调度算法wlc|rr，和您将使用的LVS的调度算法保持原则一致
    lb_algo rr
    #负载均衡转发规则 DR NAT TUN。和您将启动的LVS的工作模式设置一致
    lb_kind DR
    #虚拟地址的子网掩码
    nat_mask 255.255.255.0
    #会话保持时间，因为我们经常使用的是无状态的集群架构，所以这个设置可有可无
    #persistence_timeout 50
    #转发协议，当然是TCP
    protocol TCP

    #真实的下层Nginx节点的健康监测
    real_server 192.168.10.178 80 {
        #节点权重，
        weight 10
        #设置检查方式，可以设置HTTP_GET | SSL_GET
        HTTP_GET {
            url {
              path /
              digest ff20ad2481f97b1754ef3e12ecd3a9cc
            }
            #超时时间，秒。如果在这个时间内没有返回，则说明一次监测失败
            connect_timeout 3
            #设置多少次监测失败，就认为这个真实节点死掉了
            nb_get_retry 3
            #重试间隔
            delay_before_retry 3
        }
    }

    real_server 192.168.10.190 80 {
        weight 10
        HTTP_GET {
            url {
              path /
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
        }
    }
}


