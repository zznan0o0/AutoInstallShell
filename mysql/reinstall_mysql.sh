rm -rf /etc/mysql/ /var/lib/mysql

apt purge mysql-community-server -y
apt purge mysql-server -y

mkdir -p /etc/mysql/conf.d/
aptitude install mysql-server -y


mysql
update mysql.user set authentication_string=PASSWORD('root'),plugin='mysql_native_password' where user='root';
flush privileges;

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;
FLUSH PRIVILEGES;
exit;

vim /etc/mysql/mysql.conf.d/mysqld.cnf
#bind-address           = 127.0.0.1
vim /etc/mysql/mysql.conf.d/mysqld.cnf
[mysqld]
skip-name-resolve


service mysql restart
