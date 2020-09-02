vim /etc/sysctl.conf


net.ipv4.tcp_syncookies = 0
net.ipv4.tcp_tw_reuse=1
net.core.somaxconn = 100000

sysctl -p

vim /etc/security/limits.conf

* hard nofile 100000
* soft nofile 100000
root hard nofile 100000
root soft nofile 100000


vim /etc/nginx/nginx.conf

worker_rlimit_nofile 100000;
events {
        worker_connections 100000;
}

vim /etc/nginx/sites-available/default

upstream test{
  server 192.168.10.85:81;
  fair;
}

server {
        listen       8081;
        server_name  www.b.com;
        location / {
            proxy_pass http://test;
            proxy_set_header Host $proxy_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Via "nginx";
            client_max_body_size 5M;
        }
}


show variables like "max_connections";
show global variables like "%open_files_limit%";

vim /etc/mysql/mysql.cnf
[mysqld]
max_connections = 10000
open_files_limit = 10000

https://www.cnblogs.com/zhoujinyi/archive/2013/01/31/2883433.html




-------------------------------------------------------


https://www.cnblogs.com/sunjianguo/p/8298283.html
------------------------------
#worker_connections
worker_rlimit_nofile 65535;
events {
    worker_connections  10240;
}


----------------------------



vim /etc/security/limits.conf

* hard nofile 20000
* soft nofile 20000
root hard nofile 20000
root soft nofile 20000

vim /etc/sysctl.conf

net.ipv4.tcp_syncookies = 0
net.ipv4.tcp_tw_reuse=1 
net.ipv4.tcp_fin_timeout=1

/sbin/sysctl -p 让修改生效


vim /etc/nginx/nginx.conf

worker_processes 8;
worker_cpu_affinity 00000001 00000010 00000100 00001000 00010000 00100000 01000000;

worker_rlimit_nofile 20000;

events
{
    # use epoll;
    worker_connections 20000;
}


vim /etc/nginx/default

upstream test {
    server 192.168.10.89;
    fair;
}



server {
    listen       8080;
    server_name  www.b.com;
    client_max_body_size 10M;
    location / {
        proxy_pass http://test;
        proxy_set_header Host $proxy_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Via "nginx";
        client_max_body_size 5M;
        proxy_ignore_client_abort   on;
    }   
}


----------------------------------------------------------


# 长连接池配置（看看情况慎用）
vim /etc/nginx/default

upstream test {
    server 192.168.10.89;
    fair;
    keepalive 256;
}

server {
    listen       80;
    server_name  www.b.com;
    client_max_body_size 10M;
    location / {
        proxy_pass http://test;
        proxy_set_header Host $proxy_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Via "nginx";
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        client_max_body_size 5M;
        proxy_ignore_client_abort   on;
    }   
}











------------------------------------------------------------------



upstream http_backend {
    server 127.0.0.1:8080;

    keepalive 16;
}
server {
    …

    location /http/ {
        proxy_pass http://http_backend;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        …
    }
}



# 最大连接数
echo 50000 > /proc/sys/net/core/somaxconn
# 打开系统快速连接回收
echo 1 > /proc/sys/net/ipv4/tcp_tw_recycle
#打开空的tcp连接允许回收利用
echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse
# 不做洪水抵御
echo 0 > /proc/sys/net/ipv4/tcp_syncookies

sysctl -p

# nginx
vim /etc/nginx/nginx.conf

worker_processes  4;
worker_rlimit_nofile 20000;
events {
    worker_connections 20000;
}
http {
    keepalive_timeout 0;
}

service nginx reload

# ulimit
vim /etc/security/limits.conf

* hard nofile 20000
* soft nofile 20000
root hard nofile 20000
root soft nofile 20000

vim /etc/pam.d/su

# session required pam_limits.so


-------------------
vim /etc/sysctl.conf
net.ipv4.tcp_syncookies = 0
net.ipv4.tcp_tw_reuse=1 
net.ipv4.tcp_tw_recycle=1 
net.ipv4.tcp_fin_timeout=30
/sbin/sysctl -p 让修改生效
-----------------

https://blog.csdn.net/smartdt/article/details/78193355?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.compare&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.compare

vim /etc/sysctl.conf

net.ipv4.ip_forward = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 0
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
# *
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 30
net.ipv4.ip_local_port_range = 1024 65000



vim /etc/nginx/nginx.conf

user www www;
worker_processes 8;
worker_cpu_affinity 00000001 00000010 00000100 00001000 00010000 00100000 01000000;
error_log /www/log/nginx_error.log crit;
pid /usr/local/nginx/nginx.pid;
worker_rlimit_nofile 204800;

events
{
    use epoll;
    worker_connections 204800;
}
http
{
    include mime.types;
    default_type application/octet-stream;
    charset utf-8;
    server_names_hash_bucket_size 128;
    client_header_buffer_size 2k;
    large_client_header_buffers 4 4k;
    client_max_body_size 8m;
    sendfile on;
    tcp_nopush on;
    keepalive_timeout 60;
    fastcgi_cache_path /usr/local/nginx/fastcgi_cache levels=1:2
    keys_zone=TEST:10m
    inactive=5m;
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 4k;
    fastcgi_buffers 8 4k;
    fastcgi_busy_buffers_size 8k;
    fastcgi_temp_file_write_size 8k;

    fastcgi_cache TEST;
    fastcgi_cache_valid 200 302 1h;
    fastcgi_cache_valid 301 1d;
    fastcgi_cache_valid any 1m;
    fastcgi_cache_min_uses 1;
    fastcgi_cache_use_stale error timeout invalid_header http_500;
    open_file_cache max=204800 inactive=20s;
    open_file_cache_min_uses 1;
    open_file_cache_valid 30s;
    tcp_nodelay on;
    gzip on;
    gzip_min_length 1k;
    gzip_buffers 4 16k;
    gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_types text/plain application/x-javascript text/css application/xml;
    gzip_vary on;
    server
    {
        listen 8080;
        server_name backup.aiju.com;
        index index.php index.htm;
        root /www/html/;
        location /status
        {
            stub_status on;
        }
        location ~ .*\.(php|php5)?$
        {
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            include fcgi.conf;
        }
        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|js|css)$
        {
            expires 30d;
        }
    log_format access '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer" '
    '"$http_user_agent" $http_x_forwarded_for';
    access_log /www/log/access.log access;
    }
}


# 查看time wait
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'  



# 阿里云服务器配置
vm.swappiness = 0
kernel.sysrq = 1

net.ipv4.neigh.default.gc_stale_time = 120

# see details in https://help.aliyun.com/knowledge_detail/39428.html
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_announce = 2

# see details in https://help.aliyun.com/knowledge_detail/41334.html
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 1024
net.ipv4.tcp_synack_retries = 2
