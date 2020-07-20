import paramiko


def createSSH(config):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(config['ip'], config['port'],
                config['user'], config['password'])
    return ssh


temp = """echo 'network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      addresses:
        - %s/24
      gateway4: 192.168.2.1
      nameservers:
          addresses: [192.168.2.1, 8.8.8.8]
' > /etc/netplan/01.yaml; netplan apply;"""

temp_config = {
    "ip": "",
    "port": "22",
    "user": "root",
    "password": "root"
}


if __name__ == "__main__":
    ips = [
        "192.168.2.34",
        "192.168.2.22",
        "192.168.2.17",
        "192.168.2.38",
        "192.168.2.47",
        "192.168.2.36",
        "192.168.2.39",
        "192.168.2.27",
        "192.168.2.46",
        "192.168.2.42",
        "192.168.2.12",
        "192.168.2.48",
        "192.168.2.43",
        "192.168.2.40",
        "192.168.2.31",
        "192.168.2.30",
        "192.168.2.41",
    ]

    for v in ips:
        print(v)
        config = temp_config
        config["ip"] = v
        shell = temp % (v)
        ssh = createSSH(config)
        stdin, stdout, stderr = ssh.exec_command(shell)
        err = stderr.readlines()
        if(len(err) > 0):
            print(stdin)
            print(stdout)
            print(err)
        ssh.close()
