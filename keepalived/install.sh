apt install -y keepalived

echo "vrrp_instance VI_1 {
    state MASTER
    interface ens33
    virtual_router_id 51 # 不能重
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


vrrp_instance VI_1 {
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
}




keepalived的配置位于/etc/keepalived/keepalived.conf，配置文件格式包含多个必填/可选的配置段，部分重要配置含义如下：

global_defs: 全局定义块，定义主从切换时通知邮件的SMTP配置。
vrrp_instance: vrrp实例配置。
vrrp_script: 健康检查脚本配置。
细分下去，vrrp_instance配置段包括：

state: 实例角色。分为一个MASTER和一(多)个BACKUP。
virtual_router_id: 标识该虚拟路由器的ID，有效范围为0-255。
priority: 优先级初始值，竞选MASTER用到，有效范围为0-255。
advert_int: VRRP协议通告间隔。
interface: VIP所绑定的网卡，指定处理VRRP多播协议包的网卡。
mcast_src_ip: 指定发送VRRP协议通告的本机IP地址。
authentication: 认证方式。
virtual_ipaddress: VIP。
track_script: 健康检查脚本。
vrrp_script配置段包括：

script: 一句指令或者一个脚本文件，需返回0(成功)或非0(失败)，keepalived以此为依据判断其监控的服务状态。
interval: 健康检查周期。
weight: 优先级变化幅度。
fall: 判定服务异常的检查次数。
rise: 判定服务正常的检查次数。