###
 # @Descripttion: 
 # @version: 
 # @Author: sueRimn
 # @Date: 2020-03-11 11:11:40
 # @LastEditors: sueRimn
 # @LastEditTime: 2020-03-11 11:22:26
 ###
apt install -y software-properties-common
add-apt-repository ppa:ondrej/php
apt-get -y update
apt-get install -y php7.4
apt-get install -y php7.4-bcmath php7.4-mbstring php7.4-xml php7.4-mysql php7.4-curl php7.4-cli php7.4-common php7.4-gd php7.4-zip php-redis
echo '当前版本'
php -v