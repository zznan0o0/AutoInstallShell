vim /etc/security/limits.conf

* hard nofile 20000
* soft nofile 20000
root hard nofile 20000
root soft nofile 20000

vim /etc/sysctl.conf
net.ipv4.tcp_syncookies = 0
net.ipv4.tcp_tw_reuse = 1
net.core.somaxconn = 100000
sysctl -p

---ab---
ab -c 10000 -n 100000 192.168.10.85/index.html
1017.472
ab -c 10000 -n 100000 192.168.10.85:8080/index.html
2439.624

timeout 9435


---ng---
vim /etc/nginx/nginx.conf
worker_rlimit_nofile 10000;
events{
  worker_connections 10000;
}

ab -c 10000 -n 100000 192.168.10.85:81/index.html
751.295

ab -c 10000 -n 100000 192.168.10.85:8081/index.html
1185.985

timeout 1645