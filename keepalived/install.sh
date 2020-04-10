apt install -y keepalived

echo "vrrp_instance VI_1 {
    state MASTER
    interface ens33
    virtual_router_id 51
    priority 101
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 123456
    }
    # IP配置成你要的虚拟ip
    virtual_ipaddress {
        192.168.10.5
    }
}" > /etc/keepalived/keepalived.conf

service keepalived restart

ip addr show ens33