# !/bin/bash
mv frpc /usr/bin/
mkdir -p /var/log/frpc/
mkdir -p /etc/frpc/


echo '[common]
server_addr = xxx
server_port = xxx

token=xxx

log_file = /var/log/frpc/frpc.log
log_level = error
log_max_days = 3


[xxx]
type = http
local_port = 80
local_ip=xxx
custom_domains = xxx.atjubo.com' > /etc/frpc/frpc.ini



echo '[Unit]
Description=frp service
After=network.target syslog.target
Wants=network.target

[Service]
Type=simple
ExecStart=/usr/bin/frpc -c /etc/frpc/frpc.ini

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/frpc.service

systemctl enable frpc
systemctl start frpc