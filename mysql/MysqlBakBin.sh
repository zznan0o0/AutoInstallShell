# !/bin/bash
# ssh-copy-id -i root@192.168.10.222

MYSQL_BINLOG_PATH=/var/lib/mysql
MYSQL_HOST=192.168.10.222
MYSQL_USER=root
MYSQL_PASSWORD=root
SSH_USER=root
EXPIRE_MONTHS=3
LOCAL_BINLOG_PATH=/home/dever/backupsql
# DBLIST=("db_warehouse_glass" "db_warehouse_state_glass" "db_Trader" "db_account" "db_finance" "db_invoice" "db_juboPSS")
DBLIST=("db_test")


# 每日备份
LOCAL_BINLOG_DATE_PATH=$LOCAL_BINLOG_PATH/`date +%Y%m`
mkdir -p $LOCAL_BINLOG_DATE_PATH

MYSQL_BINLOGFILE=`/usr/bin/mysql -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD --execute="show master status\G" | grep File | awk -F': ' '{print $2}'`

/usr/bin/mysql -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD --execute="flush logs;"

/usr/bin/scp $SSH_USER@$MYSQL_HOST:$MYSQL_BINLOG_PATH/$MYSQL_BINLOGFILE $LOCAL_BINLOG_DATE_PATH

cd $LOCAL_BINLOG_DATE_PATH

/usr/bin/xz -z9 $MYSQL_BINLOGFILE

# 月初完整备份if

if [ `date +%d` = '01' ]; then
    cd $LOCAL_BINLOG_DATE_PATH

    for db in ${DBLIST[@]};do
        FILENAME="$db.sql"
        /usr/bin/mysqldump --set-gtid-purged=off -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD --databases $db > $FILENAME
        
        /usr/bin/xz -9z $FILENAME
    done
fi

# 删除EXPIRE_MONTHS月以前的文件

cd $LOCAL_BINLOG_PATH

((EXPIRE_MONTHS=$EXPIRE_MONTHS+1))
DEL_DIR_NAME=`date -d "-$EXPIRE_MONTHS month" +%Y%m`

if [ `date +%d` = '01' ] && [ -d $DEL_DIR_NAME ]; then
    rm -rf $DEL_DIR_NAME
fi

