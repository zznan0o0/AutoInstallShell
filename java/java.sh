#!/bin/bash
# 改
SERVICE_NAME=springbootEureka
PID_PATH=/var/run/$SERVICE_NAME.pid

case "$1" in
start)
    # 改
    /usr/local/jdk1.8/bin/java -jar /root/jar/springbootEureka/springbootEureka-1.0.jar --spring.config.location=/root/jar/springbootEureka/application.yml >> /var/log/springbootEureka/eureka.log 2>&1 &
    # /usr/bin/java -jar /zuul-service/rocket-zuul-0.0.1-SNAPSHOT.jar >>/zuul-service/zuul.log 2>&1 &
    #将pid写进文件
    echo $! > $PID_PATH
    ;;
stop)
    kill $(cat ${PID_PATH})
    rm ${PID_PATH}
    ;;
restart)
    $0 stop
    $0 start
    ;;
status)
    if [ -e ${PID_PATH} ]; then
        echo "${SERVICE_NAME} is running, pid=$(cat ${PID_PATH})"
    else
        echo "${SERVICE_NAME} is NOT running"
        exit 1
    fi
    ;;
*)
    echo "Usage: $0 {start|stop|status|restart}"
    ;;
esac

exit 0
