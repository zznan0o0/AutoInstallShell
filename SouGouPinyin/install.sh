apt-get install -y fcitx-bin
apt-get install -y fcitx-table

apt-get purge -y ibus
apt-get autoremove -y

dpkg -i sogoupinyin_2.2.0.0108_amd64.deb
apt-get install -f