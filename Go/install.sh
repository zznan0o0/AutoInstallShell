wget https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz
# tar -C /usr/local -xzf go1.14.3.linux-amd64.tar.gz
tar -xzf go1.14.3.linux-amd64.tar.gz

mkdir -p /usr/local/lib/golang
chmod -R 775 /usr/local/lib/golang
chown -R root:staff /usr/local/lib/golang

vim /etc/profile
# add 
export GOPATH=/usr/local/lib/golang
export GOROOT=/usr/local/go
export PATH=$PATH:/usr/local/go/bin
# Enable the go modules feature
# export GO111MODULE=on
# 镜像库
# Set the GOPROXY environment variable
export GOPROXY=https://goproxy.io



# go get golang.org/dl/go1.10.7
# go1.10.7 download