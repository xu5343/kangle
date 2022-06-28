#!/bin/bash
files="/root/s-hell"
source $files/iver
PREFIX="/vhs/kangle/ext/php"
mysql_root_password=$1
if [ "$mysql_root_password" = "" ]; then
	mysql_root_password="未设置"
fi
release=`cat /etc/*release /etc/*version 2>/dev/null | grep -Eo '([0-9]{1,2}\.){1,3}' | cut -d '.' -f1 | head -1`;

echo "正在检测安装结果................."
IP=`curl -s http://members.3322.org/dyndns/getip`;
PHPRESULT="";
case `"$PREFIX"53/bin/php -v |grep "$PHP53" -o` in
   $PHP53) PHPRESULT="${PHPRESULT}\nPHP53:\033[32;5mPHP-$PHP53已安装\033[0m";;
   *) PHPRESULT="${PHPRESULT}\nPHP53:\033[32;5mPHP-$PHP53未安装/更新\033[0m";;
esac
case `"$PREFIX"54/bin/php -v |grep "$PHP54" -o` in
   $PHP54) PHPRESULT="${PHPRESULT}\nPHP54:\033[32;5mPHP-$PHP54已安装\033[0m";;
   *) PHPRESULT="${PHPRESULT}\nPHP54:\033[32;5mPHP-$PHP54未安装/更新\033[0m";;
esac
case `"$PREFIX"55/bin/php -v |grep "$PHP55" -o` in
   $PHP55) PHPRESULT="${PHPRESULT}\nPHP55:\033[32;5mPHP-$PHP55已安装\033[0m";;
   *) PHPRESULT="${PHPRESULT}\nPHP55:\033[32;5mPHP-$PHP55未安装/更新\033[0m";;
esac
case `"$PREFIX"56/bin/php -v |grep "$PHP56" -o` in
   $PHP56) PHPRESULT="${PHPRESULT}\nPHP56:\033[32;5mPHP-$PHP56已安装\033[0m";;
   *) PHPRESULT="${PHPRESULT}\nPHP56:\033[32;5mPHP-$PHP56未安装/更新\033[0m";;
esac
case `"$PREFIX"70/bin/php -v |grep "$PHP70" -o` in
   $PHP70) PHPRESULT="${PHPRESULT}\nPHP70:\033[32;5mPHP-$PHP70已安装\033[0m";;
   *) PHPRESULT="${PHPRESULT}\nPHP70:\033[32;5mPHP-$PHP70未安装/更新\033[0m";;
esac
case `"$PREFIX"71/bin/php -v |grep "$PHP71" -o` in
   $PHP71) PHPRESULT="${PHPRESULT}\nPHP71:\033[32;5mPHP-$PHP71已安装\033[0m";;
   *) PHPRESULT="${PHPRESULT}\nPHP71:\033[32;5mPHP-$PHP71未安装/更新\033[0m";;
esac
case `"$PREFIX"72/bin/php -v |grep "$PHP72" -o` in
   $PHP72) PHPRESULT="${PHPRESULT}\nPHP72:\033[32;5mPHP-$PHP72已安装\033[0m";;
   *) PHPRESULT="${PHPRESULT}\nPHP72:\033[32;5mPHP-$PHP72未安装/更新\033[0m";;
esac
case `"$PREFIX"73/bin/php -v |grep "$PHP73" -o` in
   $PHP73) PHPRESULT="${PHPRESULT}\nPHP73:\033[32;5mPHP-$PHP73已安装\033[0m";;
   *) PHPRESULT="${PHPRESULT}\nPHP73:\033[32;5mPHP-$PHP73未安装/更新\033[0m";;
esac
if [ "$release" != "6" ]; then
case `"$PREFIX"74/bin/php -v |grep "$PHP74" -o` in
   $PHP74) PHPRESULT="${PHPRESULT}\nPHP74:\033[32;5mPHP-$PHP74已安装\033[0m";;
   *) PHPRESULT="${PHPRESULT}\nPHP74:\033[32;5mPHP-$PHP74未安装/更新\033[0m";;
esac
case `"$PREFIX"80/bin/php -v |grep "$PHP80" -o` in
   $PHP80) PHPRESULT="${PHPRESULT}\nPHP80:\033[32;5mPHP-$PHP80已安装\033[0m";;
   *) PHPRESULT="${PHPRESULT}\nPHP80:\033[32;5mPHP-$PHP80未安装/更新\033[0m";;
esac
case `"$PREFIX"81/bin/php -v |grep "$PHP81" -o` in
   $PHP81) PHPRESULT="${PHPRESULT}\nPHP81:\033[32;5mPHP-$PHP81已安装\033[0m";;
   *) PHPRESULT="${PHPRESULT}\nPHP81:\033[32;5mPHP-$PHP81未安装/更新\033[0m";;
esac
fi

clear
echo -e "————————————————————————————————————————————————————
	\033[1mＫＡＮＧＬＥＳＯＦＴ\033[0m
	\033[32;5mKangle一键脚本安装完成\033[0m
————————————————————————————————————————————————————
PHP多版本安装结果："$PHPRESULT"
请使用浏览器访问：
http://"$IP":3312/admin/
Easypanel 账号: \033[32;5madmin\033[0m 	Mysql 账号: \033[32;5mroot\033[0m
Easypanel 密码: \033[32;5mkangle\033[0m	Mysql 密码: \033[32;5m"$mysql_root_password"\033[0m
————————————————————————————————————————————————————"
