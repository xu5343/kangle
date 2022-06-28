#!/bin/bash
files="/root/s-hell"
release=`cat /etc/*release /etc/*version 2>/dev/null | grep -Eo '([0-9]{1,2}\.){1,3}' | cut -d '.' -f1 | head -1`;
source $files/config
source $files/iver

mysql_ver=$1
mysql_root_password=$2
if [ "$mysql_ver" = "" ]; then
mysql_ver="6"
fi
if [ "$mysql_root_password" = "" ]; then
mysql_root_password="mysql"
fi

echo $mysql_ver > /etc/mysql_ver

#killall mysqld

if [ "$release" = "8" ] && [ "$mysql_ver" != "8" ];then
	if [ "$mysql_ver" = "6" ]; then
		yum -y install $DOWNLOAD_FILE_URL/mysql-yum/mysql56-community-el7/mysql-community-common-${MYSQL_VERSION}.el7.x86_64.rpm
		yum -y install $DOWNLOAD_FILE_URL/mysql-yum/mysql56-community-el7/mysql-community-libs-${MYSQL_VERSION}.el7.x86_64.rpm
		yum -y install $DOWNLOAD_FILE_URL/mysql-yum/mysql56-community-el7/mysql-community-devel-${MYSQL_VERSION}.el7.x86_64.rpm
		yum -y install $DOWNLOAD_FILE_URL/mysql-yum/mysql56-community-el7/mysql-community-client-${MYSQL_VERSION}.el7.x86_64.rpm
		yum -y install $DOWNLOAD_FILE_URL/mysql-yum/mysql56-community-el7/mysql-community-server-${MYSQL_VERSION}.el7.x86_64.rpm
	elif [ "$mysql_ver" = "7" ]; then
		yum -y install $DOWNLOAD_FILE_URL/mysql-yum/mysql57-community-el7/mysql-community-common-${MYSQL_VERSION7}.el7.x86_64.rpm
		yum -y install $DOWNLOAD_FILE_URL/mysql-yum/mysql57-community-el7/mysql-community-libs-${MYSQL_VERSION7}.el7.x86_64.rpm
		yum -y install $DOWNLOAD_FILE_URL/mysql-yum/mysql57-community-el7/mysql-community-devel-${MYSQL_VERSION7}.el7.x86_64.rpm
		yum -y install $DOWNLOAD_FILE_URL/mysql-yum/mysql57-community-el7/mysql-community-client-${MYSQL_VERSION7}.el7.x86_64.rpm
		yum -y install $DOWNLOAD_FILE_URL/mysql-yum/mysql57-community-el7/mysql-community-server-${MYSQL_VERSION7}.el7.x86_64.rpm
	fi
else
	yum -y install mysql mysql-common mysql-libs mysql-devel mysql-server
fi;

if [ "$release" != "6" ] && [ `grep -c "LimitNOFILE=infinity" /usr/lib/systemd/system/mysqld.service` -eq '0' ];then
	echo "LimitNOFILE=infinity" >> /usr/lib/systemd/system/mysqld.service
	systemctl daemon-reload
fi;
chkconfig --level 2345 mysqld on

if [ "$mysql_ver" = "8" ]; then
	wget -q $DOWNLOAD_URL/config_file/mysql8.0/my.cnf -O /etc/my.cnf
	if [ "$release" = "8" ]; then
		mkdir /home/mysql
		chown -R mysql:mysql /home/mysql
	fi
elif [ "$mysql_ver" = "7" ]; then
	wget -q $DOWNLOAD_URL/config_file/mysql5.7/my.cnf -O /etc/my.cnf
else
	wget -q $DOWNLOAD_URL/config_file/mysql5.6/my.cnf -O /etc/my.cnf
fi

rm -f /home/mysql/ibdata1
rm -f /home/mysql/ibtmp1
rm -f /home/mysql/ib_logfile0
rm -f /home/mysql/ib_logfile1
service mysqld restart
#重置MySQL密码
wget -q $DOWNLOAD_URL/sh/reset.sh -O reset.sh;sh reset.sh $mysql_root_password
