#!/bin/bash
#批量ping IP地址
#ip_record.text文本一行一个IP地址
#获取ip 是否可以ping通

ipAll=$(cat ./ip.txt)

for i in $ipAll; do
    ping=$(ping -c 1 $i | grep loss | awk '{print $6}' | awk -F "%" '{print $1}')

    if [ $ping != 0 ];then
        echo "ping $i fail <------"

    else

        echo "ping $i ok"

    fi

done
