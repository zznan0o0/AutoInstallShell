add-apt-repository ppa:nginx/stable
apt-get update
apt install nginx -y
mkdir -p /etc/systemd/system/nginx.service.d
echo "[Service]
ExecStartPost=/bin/sleep 0.1" > /etc/systemd/system/nginx.service.d/override.conf
systemctl daemon-reload
systemctl restart nginx.service
# 防火墙允许
ufw app list
ufw allow "Nginx Full"