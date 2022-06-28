#!/bin/bash
files="/root/s-hell"
tmpfile="/root/hl-tmp"
source $files/config
cd $tmpfile
rm -rf *
mkdir -p $files/log
rm -rf $files/log/*
kangle_ver=$1
kangle_completed=$2
select_ver=$3
mysql_ver=$4
mysql_root_password=$5
release=`cat /etc/*release /etc/*version 2>/dev/null | grep -Eo '([0-9]{1,2}\.){1,3}' | cut -d '.' -f1 | head -1`;

function stat_iptables
{
	if [ ! -f /etc/init.d/iptables ]&&[ ! -f /usr/lib/systemd/system/firewalld.service ] ; then
		return;
	fi
	service iptables stop
	service firewalld stop
	chkconfig iptables off
	chkconfig firewalld off
	return;
}
function installkangle(){
	cd $tmpfile
	wget -q $DOWNLOAD_URL/sh/kangle.sh -O kangle.sh;sh kangle.sh $kangle_ver $kangle_completed | tee $files/log/kangle.log
}
function installep(){
	cd $tmpfile
	wget -q $DOWNLOAD_URL/sh/ep.sh -O ep.sh;sh ep.sh | tee $files/log/ep.log
}
function installftp(){
	cd $tmpfile
	wget -q $DOWNLOAD_URL/sh/ftp.sh -O ftp.sh;sh ftp.sh | tee $files/log/ftp.log
}
function installsql(){
	cd $tmpfile
	wget -q $DOWNLOAD_URL/sh/sql.sh -O sql.sh;sh sql.sh $mysql_ver $mysql_root_password | tee $files/log/sql.log
}
function installpm(){
	cd $tmpfile
	wget -q $DOWNLOAD_URL/sh/pm.sh -O upm.sh;sh upm.sh | tee $files/log/upm.log
}
function install_compile(){
	cd $tmpfile
	wget -q $DOWNLOAD_URL/sh/phpc.sh -O phpc.sh
	sh phpc.sh 56 | tee $files/log/php56.log
	ln -sf /vhs/kangle/ext/php56/bin/php /usr/bin/php
	if [ "$select_ver" = "allc" ]; then
	sh phpc.sh 53 | tee $files/log/php53.log
	sh phpc.sh 54 | tee $files/log/php54.log
	sh phpc.sh 55 | tee $files/log/php55.log
	sh phpc.sh 70 | tee $files/log/php70.log
	sh phpc.sh 71 | tee $files/log/php71.log
	sh phpc.sh 72 | tee $files/log/php72.log
	sh phpc.sh 73 | tee $files/log/php73.log
	ln -sf /vhs/kangle/ext/php73/bin/php /usr/bin/php
	if [ "$release" != "6" ]; then
	sh phpc.sh 74 | tee $files/log/php74.log
	sh phpc.sh 80 | tee $files/log/php80.log
	sh phpc.sh 81 | tee $files/log/php81.log
	ln -sf /vhs/kangle/ext/php74/bin/php /usr/bin/php
	fi
	fi
}
function install_completed(){
	cd $tmpfile
	wget -q $DOWNLOAD_URL/sh/php.sh -O php.sh
	sh php.sh php56 | tee $files/log/php56.log
	ln -sf /vhs/kangle/ext/php56/bin/php /usr/bin/php
	if [ "$select_ver" = "all" ]; then
	sh php.sh php53 | tee $files/log/php53.log
	sh php.sh php54 | tee $files/log/php54.log
	sh php.sh php55 | tee $files/log/php55.log
	sh php.sh php70 | tee $files/log/php70.log
	sh php.sh php71 | tee $files/log/php71.log
	sh php.sh php72 | tee $files/log/php72.log
	sh php.sh php73 | tee $files/log/php73.log
	ln -sf /vhs/kangle/ext/php73/bin/php /usr/bin/php
	if [ "$release" != "6" ]; then
	sh php.sh php74 | tee $files/log/php74.log
	sh php.sh php80 | tee $files/log/php80.log
	sh php.sh php81 | tee $files/log/php81.log
	ln -sf /vhs/kangle/ext/php74/bin/php /usr/bin/php
	fi
	fi
}
function installend(){
	rm -rf $tmpfile/*
	wget -q $DOWNLOAD_URL/complete.sh -O complete.sh;sh complete.sh $mysql_root_password
	exit 0
}
stat_iptables
if [ "$mysql_root_password" != "no" ]; then
installsql
fi
installkangle
installep
installftp
if [ "$select_ver" = "allc" ]||[ "$select_ver" = "defaultc" ]; then
install_compile
else
install_completed
fi
installpm
installend