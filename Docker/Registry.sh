su
docker pull registry
docker run -d -p 5000:5000 -v /docker/myregistry:/var/lib/registry
curl http://127.0.0.1:5000/v2/_catalog
echo 'because https is used by default, please add your ip to /etc/docker/daemon.json,like "insecure-registries":["192.168.10.241:5000"] and service docker restart'
echo 'please tag your image, like docker tag p7_1a2:v1 192.168.10.241:5000/p7_1a2'