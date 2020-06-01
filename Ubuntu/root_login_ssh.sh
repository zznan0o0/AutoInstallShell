apt-get install openssh-server
echo 'PermitRootLogin  yes 
PasswordAuthentication  yes' >> /etc/ssh/sshd_config
service ssh restart



echo 'greeter-show-manual-login=true' >> /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
echo 'all-guest=false ' >> /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf

vim /etc/pam.d/gdm-autologin
# auth required pam_succeed_if.so user != root quiet_success
vim  /etc/pam.d/gdm-password
# auth required pam_succeed_if.so user != root quiet_success
