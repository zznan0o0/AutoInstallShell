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
    -h | --help)
        h="h"
        echo "
-i | --image: image path
-n | --name: vmname
-c | --netcard: network card name
./importopt.sh -i ./u18_04_4_500g_root_vbox_plus.ova -n test -c em1
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

VBoxManage import "$path" --vsys 0 --vmname "$vmname"

VBoxManage modifyvm "$vmname" --nic1 bridged
VBoxManage modifyvm "$vmname" --bridgeadapter1 "$ncard"

VBoxManage startvm "$vmname" --type headless
echo "$vmname is started"
