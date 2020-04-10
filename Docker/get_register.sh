#!/bin/bash
# sudo apt install install jq
# URL替换成你的地址
URL="http://192.168.10.118:5000"

read -p "what would you do ? all or list or tag: " EVENT
echo $EVENT
if [ $EVENT = 'all' ]; then
  list_json=$(curl -s ${URL}/v2/_catalog)
  length=`echo $list_json | jq ".[] | length"`
  for ((i=0;i<length;i++))
  do
    IMAGE_NAME=`echo $list_json | jq ".repositories[${i}]"`
    IMAGE_NAME=`echo $IMAGE_NAME | sed 's/\"//g'`
    echo `curl  -s ${URL}/v2/${IMAGE_NAME}/tags/list` | jq .
  done
elif [ $EVENT = "list" ]; then
  echo  `curl  -s ${URL}/v2/_catalog` | jq .
elif [ $EVENT = "tag" ]; then
  read -p "input your image name: " IMAGE_NAME
  echo `curl  -s ${URL}/v2/${IMAGE_NAME}/tags/list` | jq .
else
  echo "please input all or list or tag !!!"
fi