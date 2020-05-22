apt-get install openssh-server
echo 'PermitRootLogin  yes 
PasswordAuthentication  yes' >> /etc/ssh/sshd_config
service ssh restart