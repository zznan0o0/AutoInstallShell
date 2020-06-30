apt install -y mono-complete
wget  http://www.nat123.com/down/nat123linux.tar.gz

mono  nat123linux.sh  service & 
mono  nat123linux.sh  autologin  username  password  &
去官网添加映射