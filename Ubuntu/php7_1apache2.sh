#!/bin/bash
su
apt-get -y update
apt install -y vim
apt install -y curl
apt-get install -y apache2
service apache2 start

apt-get install -y software-properties-common
add-apt-repository ppa:ondrej/php
apt install -y php7.1 php7.1-xml php7.1-mbstring php7.1-mysql php7.1-json php7.1-curl php7.1-cli php7.1-common php7.1-mcrypt php7.1-gd libapache2-mod-php7.1 php7.1-zip php7.1-redis