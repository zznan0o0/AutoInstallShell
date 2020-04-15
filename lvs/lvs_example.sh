#！/bin/bash
vip='192.168.1.100'
mask='255.255.255.255'
port='80'
iface='eth1:1'
rs1='192.168.0.3'
rs2='192.168.0.4'



case $1 in
start)
    ifconfig $iface $vip netmask $mask broadcast $vip up
    iptables -F
    # 配置ipvs规则
    ipvsadm -A -t ${vip}:${port} -s wrr
    ipvsadm -a -t ${vip}:${port} -r ${rs1} -g -w 1
    ipvsadm -a -t ${vip}:${port} -r ${rs2} -g -w 1
    #realserver不配置端口，dr模式不支持端口映射 
    ;;
stop)
    ipvsadm -C
    ifconfig $iface down
    ;;
*)
    echo "Usage $(basename $0) start|stop"
    exit 1
    ;;
esac