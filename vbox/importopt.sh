#!/bin/bash

while [[ $# -ge 1 ]]; do
    case $1 in
    -i | --image)
        i=$2
        shift 2
        ;;
    -n | --name)
        n=$2
        shift 2
        ;;
    -c | --netcard)
        c=$2
        shift 2
        ;;
    -m | --memory)
        m=$2
        shift 2
        ;;
    -C | --cpus)
        C=$2
        shift 2
        ;;
    -h | --help)
        h="h"
        echo "
-i | --image: image path
-n | --name: vmname
-c | --netcard: network card name
-m | --memory: memory size (MB) default 2048
-C | --cpus: cpu number default 1
./importopt.sh -i ./u18_04_4_500g_root_vbox_plus.ova -n test -c em1 -m 2048 -C 1
            "
        shift 1
        exit
        ;;
    *)
        echo "what's is $1"
        shift 1
        ;;
    esac
done

declare -A dic
dic=([i]=$i [n]=$n [c]=$c)
for k in $(echo ${!dic[*]}); do
    value="${dic[$k]}"
    if [ ! $value ]; then
        echo "not found param -$k !"
        exit
    fi
done

path=$i
vmname=$n
ncard=$c
memory=$m
cpus=$C

if [ ! $memory ]; then
    memory=2048;
fi

if [ ! $cpus ]; then
    cpus=1;
fi


VBoxManage import "$path" --vsys 0 --vmname "$vmname" --memory $memory --cpus $cpus

VBoxManage modifyvm "$vmname" --nic1 bridged
VBoxManage modifyvm "$vmname" --bridgeadapter1 "$ncard"

VBoxManage startvm "$vmname" --type headless
echo "$vmname is started"
