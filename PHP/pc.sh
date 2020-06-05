#!/bin/bash
read -p "what the version of php do you want: " ver
echo $ver

sudo rm /etc/apache2/mods-enabled/php7.*
sudo a2enmod php$ver

sudo rm /etc/alternatives/php
sudo ln -s "/usr/bin/php$ver" /etc/alternatives/php

sudo service apache2 restart

php -v