#!/bin/bash
wget https://www.php.net/distributions/php-7.4.3.tar.bz2
tar -xjf php-7.4.3.tar.bz2
cd php-7.4.3

apt install libxml2-dev -y
apt install libbz2-dev -y
apt install libsqlite3-dev -y
apt install  libcurl4-openssl-dev -y
apt install libonig-dev -y


# apt-get install libzip-dev bison autoconf build-essential pkg-config git-core\
#    libltdl-dev libbz2-dev libxml2-dev libxslt1-dev libssl-dev libicu-dev libpspell-dev\
#    libenchant-dev libmcrypt-dev libpng-dev libjpeg8-dev libfreetype6-dev libmysqlclient-dev\
#    libreadline-dev libcurl4-openssl-dev librecode-dev libsqlite3-dev libonig-dev


./configure --prefix=/usr/local/php7 --with-config-file-scan-dir=/usr/local/php7/etc/php.d --with-config-file-path=/usr/local/php7/etc --enable-mbstring --enable-zip --enable-bcmath --enable-pcntl --enable-ftp --enable-xml --enable-shmop --enable-soap --enable-intl --with-openssl --enable-exif --enable-calendar --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-opcache --enable-fpm --enable-session --enable-sockets --enable-mbregex --enable-wddx --with-curl --with-iconv --with-gd --with-jpeg-dir=/usr --with-png-dir=/usr --with-zlib-dir=/usr --with-freetype-dir=/usr --enable-gd-jis-conv --with-openssl --with-pdo-mysql=mysqlnd --with-gettext=/usr --with-zlib=/usr --with-bz2=/usr --with-recode=/usr --with-xmlrpc --with-mysqli=mysqlnd


make install
