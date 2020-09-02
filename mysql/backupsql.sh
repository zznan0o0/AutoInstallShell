# !/bin/bash
FILEPATH=/home/dever/backupsql/`date +%Y`/`date +%m`/`date +%d`
mkdir -p $FILEPATH
cd $FILEPATH


DBLIST=("db_warehouse_glass" "db_warehouse_state_glass" "db_Trader" "db_account" "db_finance" "db_invoice" "db_juboPSS")

for db in ${DBLIST[@]};do
    FILENAME="$db.sql"
    mysqldump -uroot -proot -h192.168.10.89 --databases $db > $FILENAME
    
    xz -9z $FILENAME
done

