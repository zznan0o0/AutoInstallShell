#!/bin/bash
echo "---starting---"
echo $(vboxmanage list runningvms)
echo "---end---"

read -p "want your look vmname :" vmname
echo $vmname
echo $(VBoxManage guestproperty enumerate $vmname | grep "Net.*V4.*IP")
