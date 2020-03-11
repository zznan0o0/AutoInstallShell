#!/bin/bash
read -p "what the version of php do you want: " ver
echo $ver

rm /etc/alternatives/php
rm /etc/alternatives/php-config
rm /etc/alternatives/phpize

ln -s "/usr/bin/php$ver" /etc/alternatives/php
ln -s "/usr/bin/php-config$ver" /etc/alternatives/php-config
ln -s "/usr/bin/phpize$ver" /etc/alternatives/phpize
php -v
