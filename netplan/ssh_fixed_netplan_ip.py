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
      dhcp4: no
      dhcp6: no
      addresses:
        - %s/24
      gateway4: 192.168.2.1
      nameservers:
          addresses: [192.168.2.1, 8.8.8.8]
' > /etc/netplan/01.yaml; mv /etc/netplan/50-cloud-init.yaml /etc/netplan/50.bak && /usr/sbin/netplan --debug apply; """

temp_config = {
    "ip": "",
    "port": "22",
    "user": "root",
    "password": "root"
}


if __name__ == "__main__":
    ips = [
        "192.168.2.127",
        "192.168.2.129",
        "192.168.2.102",
 


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
