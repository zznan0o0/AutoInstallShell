#!/bin/bash

OLDIFS=$IFS
IFS=$'\n'
for v in $(vboxmanage list runningvms); 
do 
name=$(echo "$v" | awk -F '"' '{print $2}')
value=$(VBoxManage guestproperty enumerate $name | grep "Net.*V4.*IP")
echo "machine name: $name $value"
done
IFS="$OLDIFS"