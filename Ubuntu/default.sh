将apachectl 拷贝
cp /usr/local/apache2/bin/apachectl  /etc/init.d/httpd

2、设置开机自己启动 或者用 sysv-rc-conf
sudo update-rc.d -f httpd defaults  
service httpd start 即可
查看状态
service httpd  status 