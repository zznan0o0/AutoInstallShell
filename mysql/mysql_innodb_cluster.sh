# ip改为了155 156 157

# 安装工具16.04的根据具体系统版本下载对应版本
wget https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell_8.0.19-1ubuntu16.04_amd64.deb
dpkg -i mysql-shell_8.0.19-1ubuntu16.04_amd64.deb
wget https://dev.mysql.com/get/Downloads/MySQL-Router/mysql-router-community_8.0.19-1ubuntu16.04_amd64.deb
dpkg -i mysql-router-community_8.0.19-1ubuntu16.04_amd64.deb

# 修改主机名对应 mysql-node01、mysql-node02、mysql-node03
vim /etc/hostname
reboot

echo "
192.168.10.154 mysql-node01
192.168.10.155 mysql-node02
192.168.10.156 mysql-node03
" >> /etc/hosts


hostnamectl --transient set-hostname mysql-node01
hostnamectl # 查看是否有mysql-node01


# mysqld添加配置
vim /etc/mysql/mysql.conf.d/mysqld.cnf

# -----------------
#高可用
server_id=1
gtid_mode=ON
enforce_gtid_consistency=ON
master_info_repository=TABLE
relay_log_info_repository=TABLE
binlog_checksum=NONE
log_slave_updates=ON
log_bin=binlog
binlog_format=ROW

transaction_write_set_extraction=XXHASH64

#主从复制配置
loose-group_replication_group_name="aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
#注意：这里的地址不能用 node01:24901 这种写法，要用IP，否则无法通信
loose-group_replication_local_address= "192.168.10.157:24901"
loose-group_replication_group_seeds= "192.168.10.155:24901,192.168.10.156:24901,192.168.10.157:24901"
loose-group_replication_single_primary_mode=TRUE

#loose-group_replication_bootstrap_group= off
#loose-group_replication_enforce_update_everywhere_checks= FALSE
#loose-group_replication_start_on_boot=off

disabled_storage_engines = MyISAM,BLACKHOLE,FEDERATED,CSV,ARCHIVE
report_port = 3306

# -------------


# mysqlsh进入命令
shell.connect('root@localhost:3306');
# 输入密码
dba.configureLocalInstance(); # 查看实例状态
# -------------------------
# 如果报错Cannot use host 'ubuntu' for instance 'ubuntu:3306' 去/etc/hosts 里把ubuntu 改成127.0.0.1
# -------------------------


# 创建集群
shell.connect('root@mysql-master01:3306');
var cluster = dba.createCluster('MysqlCluster');
# var c = dba.createCluster('mc', {multiMaster: true})


# -------------------------
缺少/usr/lib/mysql/plugin/group_replication.so
可能是因为用apt安装的mysql默认不带group_replication，重新安装一下
apt-get update
wget https://dev.mysql.com/get/mysql-apt-config_0.8.9-1_all.deb
dpkg -i mysql-apt-config_0.8.9-1_all.deb
apt-get update
# apt安装一下aptitude
aptitude install  mysql-server -y

# my_print_defaults: Can't read dir of -----------
mkdir -p /etc/mysql/conf.d/
# ------------------------------------------------


# -------------------------

cluster.status();

# mysql-node02 --------------------------------------------------------------------------------------


echo "
192.168.10.154 mysql-node01
192.168.10.155 mysql-node02
192.168.10.156 mysql-node03
" >> /etc/hosts


hostnamectl --transient set-hostname mysql-node02
hostnamectl # 查看是否有mysql-node02


# mysqld添加配置
vim /etc/mysql/mysql.conf.d/mysqld.cnf
# ----------------------
#高可用
server_id=2
gtid_mode=ON
enforce_gtid_consistency=ON
master_info_repository=TABLE
relay_log_info_repository=TABLE
binlog_checksum=NONE
log_slave_updates=ON
log_bin=binlog
binlog_format=ROW

transaction_write_set_extraction=XXHASH64

#主从复制配置
loose-group_replication_group_name="aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
#注意：这里的地址不能用 node01:24901 这种写法，要用IP，否则无法通信
loose-group_replication_local_address= "192.168.10.155:24901"
loose-group_replication_group_seeds= "192.168.10.154:24901,192.168.10.155:24901,192.168.10.156:24901"
loose-group_replication_single_primary_mode=TRUE

#loose-group_replication_bootstrap_group= off
#loose-group_replication_enforce_update_everywhere_checks= FALSE
#loose-group_replication_start_on_boot=off

disabled_storage_engines = MyISAM,BLACKHOLE,FEDERATED,CSV,ARCHIVE
report_port = 3306

# -----------------------------------

# 重启mysql
service mysql restart


# mysqlsh进入命令
shell.connect('root@localhost:3306');
# 输入密码
dba.configureLocalInstance(); # 查看实例状态
# -------------------------
# 如果报错Cannot use host 'ubuntu' for instance 'ubuntu:3306' 去/etc/hosts 里把ubuntu 改成127.0.0.1
# -------------------------




# vim /etc/mysql/mysql.conf.d/mysqld.cnf 有问题
# # 在末尾添加
# group_replication_allow_local_disjoint_gtids_join=ON


# 在node1

cluster.addInstance('root@mysql-node02:3306');