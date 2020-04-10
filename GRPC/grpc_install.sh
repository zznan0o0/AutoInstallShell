#!/bin/bash
# php-pear php7.4-dev就不管了自己apt去吧
apt install zlib1g-dev -y
pecl install grpc
pecl install protobuf
snap install protobuf --classic
ln -s /snap/bin/protoc /usr/bin/

git clone -b v1.27.x https://gitee.com/mirrors/grpc.git
git submodule update --init
make grpc_php_plugin
# 编译完成后会给到grpc_php_plugin插件的位置
# 将grpc_php_plugin 移动到 /usr/local/bin 目录下

wget https://gitee.com/ibaicai/fileStore/raw/master/grpc/grpc_php_plugin
mv grpc_php_plugin /usr/local/bin/

# /etc/php/7.4/cli/php.ini 中添加 
# extension=grpc.so
# extension=protobuf.so