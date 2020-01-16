#!/bin/bash
su
cd /etc/apt/
cp sources.list  sources.list.bak
echo '
#阿里云源
deb http://mirrors.aliyun.com/ubuntu/ disco main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ disco main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ disco-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ disco-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ disco-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ disco-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ disco-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ disco-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ disco-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ disco-proposed main restricted universe multiverse

#中科大源
deb https://mirrors.ustc.edu.cn/ubuntu/ disco main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ disco main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ disco-updates main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ disco-updates main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ disco-backports main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ disco-backports main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ disco-security main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ disco-security main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ disco-proposed main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ disco-proposed main restricted universe multiverse

#163源
deb http://mirrors.163.com/ubuntu/ disco main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ disco-security main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ disco-updates main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ disco-proposed main restricted universe multiverse
deb http://mirrors.163.com/ubuntu/ disco-backports main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ disco main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ disco-security main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ disco-updates main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ disco-proposed main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ disco-backports main restricted universe multiverse

#清华源
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ disco main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ disco main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ disco-updates main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ disco-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ disco-backports main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ disco-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ disco-security main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ disco-security main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ disco-proposed main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ disco-proposed main restricted universe multiverse

' > sources.list

apt update
