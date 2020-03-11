#!/bin/bash
read -p "what the version of php do you want: " ver
echo $ver

rm /etc/alternatives/php

ln -s "/usr/bin/php$ver" /etc/alternatives/php
php -v
