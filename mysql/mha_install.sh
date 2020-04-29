wget https://github.com/yoshinorim/mha4mysql-manager/releases/download/v0.58/mha4mysql-manager_0.58-0_all.deb
dpkg -i mha4mysql-manager_0.58-0_all.deb
apt-get -f install -y
dpkg -i mha4mysql-manager_0.58-0_all.deb



# 154 管理节点管理节点不能是某台mysql机子
usermod -a -G mysql dever
ssh-keygen -t rsa  
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.10.157
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.10.178
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.10.190

# 157 master
usermod -a -G mysql dever
ssh-keygen -t rsa  
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.10.178
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.10.190

# 178 node
usermod -a -G mysql dever
ssh-keygen -t rsa  
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.10.157
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.10.190

# 190 node
usermod -a -G mysql dever
ssh-keygen -t rsa  
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.10.178
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.10.157


# 三台机子下都创建相关目录
mkdir -p /var/lib/mha
mkdir -p /etc/mha

chmod -R 775 /var/lib/mha
chmod -R 775 /etc/mha
chown -R dever:dever /var/lib/mha
chown -R dever:dever /etc/mha

vim /etc/mha/default.conf
# ------------
[server default]
#mysql用戶名，需要的权限：Super,select,create,insert,update,delete,drop,reload
user=root
#mysql密码
password=root
#ssh免密钥登录的帐号名
ssh_user=dever
#mysql复制帐号
repl_user=slave
#mysql复制密码
repl_password=slave
#ping间隔，用来检测master是否正常，默认是3秒，尝试三次没有回应的时候自动进行failover
ping_interval=1

#数据目录,主要该目录的权限，需要有创建的权限
manager_workdir=/var/lib/mha
#日志文件
manager_log=/var/lib/mha/manager.log
#另外2台机子在运行时候需要创建的目录，注意ssh-keygen帐号的权限问题
remote_workdir=/var/lib/mha

#master_ip_failover_script＝/usr/bin/master_ip_failover
#master_ip_online_change_script=/usr/bin/master_ip_online_change
#shutdown_script=/usr/bin/power_manager
#report_script=/usr/bin/send_report
#secondary_check_script= masterha_secondary_check -s remote_host1 -s remote_host2
[server1] 
hostname=192.168.10.157
#binlog目录 
master_binlog_dir=/var/lib/mysql
#master机宕掉后,优先启用这台作为新master
candidate_master=1
#默认情况下如果一个slave落后master 100M的relay logs的话，MHA将不会选择该slave作为一个新的master，因为对于这个slave的恢复需要花费很长时间，通过设置check_repl_delay=0,MHA触发切换在选择一个新的master的时候将会忽略复制延时，这个参数对于设置了candidate_master=1的主机非常有用，因为这个候选主在切换的过程中一定是新的master
check_repl_delay=0
[server2] 
hostname=192.168.10.178
master_binlog_dir=/var/log/mysql 
candidate_master=1 
[server3] 
hostname=192.168.10.190
master_binlog_dir=/var/log/mysql 
#candidate_master=1
# -------------



# 检查ssh
masterha_check_ssh --conf=/etc/mha/default.conf
# 检查主从
masterha_check_repl --conf=/etc/mha/default.conf

# Error happened on checking configurations. Redundant argument in sprintf at /usr/share/perl5/MHA/NodeUtil.pm line 190.
# ----------------------------
# vim /usr/share/perl5/MHA/NodeUtil.pm
sub parse_mysql_major_version($) {
  my $str = shift;
  my $result = sprintf( '%03d%03d', $str =~ m/(\d+)/g );
  return $result;
}

# 改为

sub parse_mysql_major_version($) {
  my $str = shift;
  $str =~ /(\d+)\.(\d+)/;
  my $strmajor = "$1.$2";
  my $result = sprintf( '%03d%03d', $strmajor =~ m/(\d+)/g );
  return $result;
}

# ----------------------------

masterha_manager --conf=/etc/mha/default.conf --ignore_last_failover 

# --ignore_last_failover：在缺省情况下，如果MHA检测到连续发生宕机，且两次宕机间隔不足8小时的话，则不会进行Failover，之所以这样限制是为了避免ping-pong效应。该参数代表忽略上次MHA触发切换产生的文件，默认情况下，MHA发生切换后会在日志目录，也就是上面我设置的/data产生app1.failover.complete文件，下次再次切换的时候如果发现该目录下存在该文件将不允许触发切换，除非在第一次切换后收到删除该文件

# --remove_dead_master_conf： 该参数代表当发生主从切换后，老的主库将会从配置文件中移除，一般情况下不需要开启