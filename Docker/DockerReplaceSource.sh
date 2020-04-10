mkdir -p /etc/docker
echo '{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"],
  "insecure-registries": ["192.168.10.116:5000", "192.168.10.6:5000", "192.168.10.214:5000"]
}' > /etc/docker/daemon.json
