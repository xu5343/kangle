#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
release=`cat /etc/*release /etc/*version 2>/dev/null | grep -Eo '([0-9]{1,2}\.){1,3}' | cut -d '.' -f1 | head -1`;

# Check if user is root
if [ $(id -u) != "0" ]; then
echo -e "————————————————————————————————————————————————————
抱歉！检测到您不是使用root权限执行本脚本.
请使用root账号登陆ssh运行本脚本
————————————————————————————————————————————————————"
exit 1
fi

clear
echo -e "————————————————————————————————————————————————————
正在为您重置MySQL密码. 正在处理中..........
————————————————————————————————————————————————————"

mysql_root_password=$1
if [ "$mysql_root_password" = "" ]; then
mysql_root_password="mysql"
fi

mysql_ver=`cat /etc/mysql_ver`

printf "停止MySQL服务中......\n"
service mysqld stop
printf "开始设置MySQL权限表\n"
if [ -f /usr/bin/mysqld_safe ]; then
	/usr/bin/mysqld_safe --skip-grant-tables --skip-networking >/dev/null 2>&1 &
else
	/usr/sbin/mysqld --user=root --skip-grant-tables --skip-networking >/dev/null 2>&1 &
fi
printf "正在刷新权限表与进行重置密码\n"
sleep 5
printf "现在设置MySQL密码('$mysql_root_password') MySQL账号'root'\n"
if [ "$mysql_ver" = "8" ]; then
	if [ "$release" = "8" ]; then
		/usr/bin/mysql -u root mysql << EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${mysql_root_password}';
FLUSH PRIVILEGES;
EOF
	else
		/usr/bin/mysql -u root mysql << EOF
FLUSH PRIVILEGES;
set global validate_password.policy=0;
set global validate_password.length=4;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${mysql_root_password}';
FLUSH PRIVILEGES;
EOF
		sed -i 's/#validate_password./validate_password./' /etc/my.cnf
	fi
elif [ "$mysql_ver" = "7" ]; then
/usr/bin/mysql -u root mysql << EOF
DELETE FROM user WHERE User!='root' OR (User = 'root' AND Host != 'localhost');
UPDATE user SET authentication_string = PASSWORD('${mysql_root_password}'), password_expired = 'N' WHERE User = 'root';
FLUSH PRIVILEGES;
EOF
sed -i 's/#validate_password_/validate_password_/' /etc/my.cnf
else
/usr/bin/mysql -u root mysql << EOF
DELETE FROM user WHERE User!='root' OR (User = 'root' AND Host != 'localhost');
UPDATE user SET password = PASSWORD('${mysql_root_password}') WHERE User = 'root';
FLUSH PRIVILEGES;
EOF
fi

reset_status=`echo $?`
if [ $reset_status = "0" ]; then
printf "MySQL密码设置成功.现在恢复设置MySQL权限表\n"
killall mysqld
sleep 3
rm -f /var/lib/mysql/ib_logfile0
rm -f /var/lib/mysql/ib_logfile1
printf "正在重启MySQL服务\n"
service mysqld restart
echo -e "————————————————————————————————————————————————————
已为您重置MySQL密码.
↓您的mysql密码为↓
\033[33m${mysql_root_password}\033[0m
————————————————————————————————————————————————————"
else
echo -e "————————————————————————————————————————————————————
抱歉！无法为您重置MySQL密码. 
————————————————————————————————————————————————————"
fi
