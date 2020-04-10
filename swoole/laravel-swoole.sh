#!/bin/bash
apt install -y php7.4-dev
apt install -y php-pear 
pecl install swoole

# add extension=swoole.so
vim /etc/php/7.4/cli/php.ini
# 编辑添加 extension=swoole.so

# 项目下
# 安装laravel-swoole
composer require swooletw/laravel-swoole

# 生成配置文件,生成的文件在config下
php artisan vendor:publish --tag=laravel-swoole
# 以swoole启动laravel
php artisan swoole:http start