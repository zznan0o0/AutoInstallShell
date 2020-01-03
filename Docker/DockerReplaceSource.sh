mkdir -p /etc/docker
echo '{"registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]}' > /etc/docker/daemon.json
