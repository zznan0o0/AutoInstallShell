cp -rf ./app ../
# 配置文件在这里运行init.sh之前先改配置./config/apollo.php,不然第一次拉取数据会失败,运行完init.sh之后可以在laravel/config/apollo.php里改
# 拉完数据会覆盖.env文件所以应该把.env数据保存在apollo里
cp -rf ./config ../

CUE_DIR=$(pwd)

cd ..
CUR_DIR_AHEAD=$(pwd)

cd $CUE_DIR

# cd $CUR_DIR_AHEAD;rm -f bootstrap/cache/config.php;php artisan config:cache;
# 30秒一次觉得少的自己调整,一个机子多项目请注意会覆盖的
cat > crontab << EOF
* * * * * (cd $CUR_DIR_AHEAD;php artisan apollo:get;) >> $CUE_DIR/apollo.log 2>&1;(cd $CUR_DIR_AHEAD;rm -f bootstrap/cache/config.php;php artisan config:cache;)
* * * * * (sleep 30;cd $CUR_DIR_AHEAD;php artisan apollo:get;) >> $CUE_DIR/apollo.log 2>&1;(cd $CUR_DIR_AHEAD;rm -f bootstrap/cache/config.php;php artisan config:cache;)
EOF

crontab ./crontab

cd $CUR_DIR_AHEAD;
# 手动更新也是下面几句句
php artisan config:clear;
php artisan apollo:get;
php artisan config:cache;
