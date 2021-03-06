主
vim /etc/mysql/my.cnf
下添加
[mysqld]
server_id=154
log-bin=mysql-bin 
binlog_format=mixed
# relay-log=/home/data/mysql/binlog/mysql-relay-bin

重启mysql
service mysql restart

进入mysql
分配账号密码
GRANT replication slave ON *.* TO 'slave'@'%' IDENTIFIED BY 'slave'; 

show master status;
得到
mysql-bin.000003  438

从
vim /etc/mysql/my.cnf
下添加
[mysqld]
server_id=155
log-bin=mysql-bin 
binlog_format=mixed
# relay-log=/home/data/mysql/binlog/mysql-relay-bin

service mysql restart


进入mysql
stop slave;

change master to master_host='192.168.10.154',master_user='slave',master_password='slave',master_log_file='mysql-bin.000003',master_log_pos=438;
start slave;
show slave status\G

-----------------
查看信息如果报这个错的话The slave I/O thread stops because master and slave have equal MySQL server UUIDs，可能因为系统镜像是复制的所以/var/lib/mysql/auto.cnf里id是一样的，停止mysql 删除这个文件重启即可
也可能是这个
[mysqld]
server_id=155
# 有节点停止后
stop slave;
reset slave;
start slave;

# 为了避免从节点进行写入从设置只读
SET GLOBAL super_read_only=1;
SET GLOBAL read_only=1;