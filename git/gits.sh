# !/bin/bash

args=$@
push(){
    git add .
    git commit -m $1
    git pull
    git push
}

merge(){
    git add .
    git commit -m $3
    git checkout $2
    git pull
    git merge $1
}

install(){
    sudo chmod +x ./gits.sh
    sudo mv ./gits.sh /usr/local/bin/gits
}

help(){
    echo '
gits push <"提交说明">: 简化push流程
gits merge <source> <target> <"提交说明"> : 简化合并流程source-> target,比如: gits merge develop master "提交说明"
gits install: 移动到bin下
gits help | --help | -h: 查看帮助
    '
}

case $1 in
"push")
    echo "---------------push-----------------"
    push $2

;;

"merge")
    echo "---------------merge----------------"
    merge $2 $3 $4
;;

"install")
    echo "---------------install---------------"
    install
;;
*)
    echo "help"
    help
;;
esac