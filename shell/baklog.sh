LOGFile="/var/log/ngrok/ngrok.log"
LOGPATH="/var/log/ngrok"
TODAY=`date +%Y-%m-%d`


cp $LOGFile "$LOGPATH/ngrok-$TODAY.log"
cat /dev/null > $LOGFile