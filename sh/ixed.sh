#!/bin/bash
files="/root/s-hell"
source $files/config
PREFIX="/vhs/kangle/ext"
SYS="i386"
if test `arch` = "x86_64"; then
	SYS="x86_64"
fi


for line in `ls $PREFIX`; do

if [ "$line" = "php53" ];then
	php_version="5.3"
elif [ "$line" = "php54" ];then
	php_version="5.4"
elif [ "$line" = "php55" ];then
	php_version="5.5"
elif [ "$line" = "php56" ];then
	php_version="5.6"
elif [ "$line" = "php70" ];then
	php_version="7.0"
elif [ "$line" = "php71" ];then
	php_version="7.1"
elif [ "$line" = "php72" ];then
	php_version="7.2"
elif [ "$line" = "php73" ];then
	php_version="7.3"
elif [ "$line" = "php74" ];then
	php_version="7.4"
elif [ "$line" = "php80" ];then
	php_version="8.0"
fi
if [ -d $PREFIX/$line ];then
file="ixed-$SYS-${php_version}.zip"
wget -c $DOWNLOAD_FILE_URL/file/$file -O $file
unzip $file
mkdir -p $PREFIX/$line/ixed
rm -rf $PREFIX/$line/ixed/ixed.${php_version}.lin
mv -f ixed.${php_version}.lin $PREFIX/$line/ixed/ixed.${php_version}.lin
echo "PHP-${php_version} SG11组件安装完成"
fi
done;

echo "正在重启环境"
/vhs/kangle/bin/kangle -q
killall -9 kangle
sleep 1
/vhs/kangle/bin/kangle
echo "SG11组件更新完成"
