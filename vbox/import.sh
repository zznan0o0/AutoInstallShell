#!/bin/bash
read -p "where is your image path :" path
echo $path

read -p "what's  your vmname :" vmname
echo $vmname

read -p "what's  your network card name :" ncard
echo $ncard

echo "wait..."
VBoxManage  import $path --vsys 0 --vmname $vmname

VBoxManage modifyvm $vmname --nic1 bridged
VBoxManage modifyvm $vmname --bridgeadapter1 $ncard

VBoxManage startvm $vmname --type headless
echo "$vmname is started"