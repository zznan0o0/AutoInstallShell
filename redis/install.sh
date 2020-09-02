add-apt-repository ppa:chris-lea/redis-server -y
apt update -y
apt-get install redis-server -y
apt-get install ruby ruby-dev gcc
gem install redis-dump

systemctl enable redis-server

# 开机不自启
cd /etc/init.d/
update-rc.d  redis-server  enable