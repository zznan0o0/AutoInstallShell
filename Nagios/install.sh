# https://linux265.com/news/3506.html

apt install autoconf gcc libc6 make wget unzip apache2 php libapache2-mod-php7.2 libgd-dev automake -y 
apt install libmcrypt-dev libssl-dev bc gawk dc build-essential libnet-snmp-perl gettext -y

wget https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz

tar zxf nagios-*.tar.gz
cd nagioscore-nagios-*/
# 检查依赖
./configure --with-httpd-conf=/etc/apache2/sites-enabled

make all

make install-groups-users
usermod -a -G nagios www-data

make install
make install-commandmode
make install-config
make install-webconf

a2enmod rewrite
a2enmod cgi
service apache2 restart

htpasswd -c /usr/local/nagios/etc/htpasswd.users nagios

wget -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.3.3.tar.gz
tar -zxf nagios-plugins.tar.gz
cd nagios-plugins
# ./tools/setup
./configure
make
make install



