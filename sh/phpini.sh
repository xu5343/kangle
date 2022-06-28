#!/bin/bash
files="/root/s-hell"
source $files/config

PREFIX="/vhs/kangle/ext/tpl_php52"
if [ -d "$PREFIX" ];then
wget $DOWNLOAD_URL/config_file/php52-templete.ini -O $PREFIX/php-templete.ini
fi
PREFIX="/vhs/kangle/ext/php53"
if [ -d "$PREFIX" ];then
wget $DOWNLOAD_URL/config_file/php53-templete.ini -O $PREFIX/php-templete.ini
fi
PREFIX="/vhs/kangle/ext/php54"
if [ -d "$PREFIX" ];then
wget $DOWNLOAD_URL/config_file/php54-templete.ini -O $PREFIX/php-templete.ini
fi
PREFIX="/vhs/kangle/ext/php55"
if [ -d "$PREFIX" ];then
wget $DOWNLOAD_URL/config_file/php55-templete.ini -O $PREFIX/php-templete.ini
fi
PREFIX="/vhs/kangle/ext/php56"
if [ -d "$PREFIX" ];then
wget $DOWNLOAD_URL/config_file/php56-templete.ini -O $PREFIX/php-templete.ini
wget $DOWNLOAD_URL/config_file/php-node.ini -O $PREFIX/etc/php-node.ini
fi
PREFIX="/vhs/kangle/ext/php70"
if [ -d "$PREFIX" ];then
wget $DOWNLOAD_URL/config_file/php70-templete.ini -O $PREFIX/php-templete.ini
fi
PREFIX="/vhs/kangle/ext/php71"
if [ -d "$PREFIX" ];then
wget $DOWNLOAD_URL/config_file/php71-templete.ini -O $PREFIX/php-templete.ini
fi
PREFIX="/vhs/kangle/ext/php72"
if [ -d "$PREFIX" ];then
wget $DOWNLOAD_URL/config_file/php72-templete.ini -O $PREFIX/php-templete.ini
fi
PREFIX="/vhs/kangle/ext/php73"
if [ -d "$PREFIX" ];then
wget $DOWNLOAD_URL/config_file/php73-templete.ini -O $PREFIX/php-templete.ini
fi
PREFIX="/vhs/kangle/ext/php74"
if [ -d "$PREFIX" ];then
wget $DOWNLOAD_URL/config_file/php74-templete.ini -O $PREFIX/php-templete.ini
fi
PREFIX="/vhs/kangle/ext/php80"
if [ -d "$PREFIX" ];then
wget $DOWNLOAD_URL/config_file/php80-templete.ini -O $PREFIX/php-templete.ini
fi
PREFIX="/vhs/kangle/ext/php81"
if [ -d "$PREFIX" ];then
wget $DOWNLOAD_URL/config_file/php81-templete.ini -O $PREFIX/php-templete.ini
fi
/vhs/kangle/bin/kangle -r
echo -e "————————————————————————————————————————————————————
安装完成
————————————————————————————————————————————————————"