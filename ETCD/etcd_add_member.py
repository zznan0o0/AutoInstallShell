import sys
import subprocess
from urllib import parse

# 执行文件带上参数
# python3 etcd_add_member.py 'NAME=machine-1&HOST=http://192.168.10.79&ENDPOINTS=http://192.168.10.121:2379'

args = sys.argv
query_dict = parse.parse_qs(args[1])

# NAME = 'machine-1'
# HOST = 'http://192.168.10.79'
# ENDPOINTS = 'http://192.168.10.121:2379'

NAME = query_dict['NAME'][0]
HOST = query_dict['HOST'][0]
ENDPOINTS = query_dict['ENDPOINTS'][0]


add_member_shell = 'etcdctl  --endpoints=%s member add %s --peer-urls=%s:2380' % (ENDPOINTS, NAME, HOST)
status, output = subprocess.getstatusoutput(add_member_shell)

ETCD_INITIAL_CLUSTER = output.split('\n')[-3].split('ETCD_INITIAL_CLUSTER=')[1]


start_member_shell = """ nohup etcd --data-dir=data.etcd --name %s \
    --initial-advertise-peer-urls %s:2380 --listen-peer-urls %s:2380 \
    --advertise-client-urls http://localhost:2379,http://127.0.0.1:2379,%s:2379 --listen-client-urls http://0.0.0.0:2379 \
    --initial-cluster %s \
    --initial-cluster-state existing --initial-cluster-token token-01 > nohup.out 2>&1 & """ % (NAME, HOST, HOST, HOST, ETCD_INITIAL_CLUSTER)

status, output = subprocess.getstatusoutput(start_member_shell)