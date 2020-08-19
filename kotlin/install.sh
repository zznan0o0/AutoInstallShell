# https://blog.csdn.net/PANJU_/article/details/77413687
https://github.com/JetBrains/kotlin/releases/tag/v1.3.71
下载对应版本的kotlin-native-linux-1.3.71.tar.gz
apt install openjdk-11-jre-headless

mv /home/dever/download/kotlin-native-linux-1.3.71 /opt/kotlin

vim /etc/profile
KOTLIN_HOME=/opt/kotlin
PATH=${PATH}:${KOTLIN_HOME}/bin
export KOTLIN_HOME PATH

source  /etc/profile