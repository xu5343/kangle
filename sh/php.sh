#!/bin/bash
files="/root/s-hell"
source $files/config
source $files/iver
PREFIX="/vhs/kangle/ext/"
intallphpv=$1
force_install=$2
ARCH="x86"
if test `arch` = "x86_64"; then
	ARCH="x86_64"
fi
release=`cat /etc/*release /etc/*version 2>/dev/null | grep -Eo '([0-9]{1,2}\.){1,3}' | cut -d '.' -f1 | head -1`;

if [ "$intallphpv" = "php74" ] && [ "$release" = "6" ]; then
	echo "你的操作系统CentOS ${release} 不支持安装 PHP-7.4，已跳过" && exit 1;
fi
if [ "$intallphpv" = "php80" ] && [ "$release" = "6" ]; then
	echo "你的操作系统CentOS ${release} 不支持安装 PHP-8.0，已跳过" && exit 1;
fi
if [ "$intallphpv" = "php81" ] && [ "$release" = "6" ]; then
	echo "你的操作系统CentOS ${release} 不支持安装 PHP-8.1，已跳过" && exit 1;
fi

function install_libzip()
{
if [ "$release" = "8" ]; then
	if [ ! -f /usr/lib64/libzip.so ]; then
		yum -y install libzip libzip-devel
	fi
else
	if [ ! -d /usr/local/lib/pkgconfig ]; then
		yum -y remove libzip libzip-devel
		wget --no-check-certificate -O libzip-1.3.2.tar.gz $DOWNLOAD_FILE_URL/file/libzip-1.3.2.tar.gz
		tar xvf libzip-1.3.2.tar.gz
		cd libzip-1.3.2
		./configure
		make
		make install
		ln -s /usr/local/lib/libzip.so.5 /usr/lib64/libzip.so.5
		ln -s /usr/local/lib/libzip.so /usr/lib64/libzip.so
		cd ..
		rm -rf libzip-1.3.2 libzip-1.3.2.tar.gz
	fi
fi
}

function install_oniguruma()
{
	if [ ! -f /usr/include/oniguruma.h ]; then
		yum -y install oniguruma oniguruma-devel;
	fi
	yum -y install libsodium-devel libwebp-devel;
}

function install_libwebp()
{
	if [ ! -f /usr/lib64/libwebp.so ]; then
		yum -y install libwebp-devel;
	fi
}

function install_libicu()
{
	if [ ! -f /usr/lib64/libicudata.so ]; then
		yum -y install libicu-devel;
	fi
}

function install_curl()
{
if ! openssl version | grep -i "openssl 1.0"; then
	if [ ! -f /usr/local/openssl-1.0.2u/bin/openssl ]; then
		wget $DOWNLOAD_FILE_URL/file/openssl-1.0.2u.tar.gz -O openssl-1.0.2u.tar.gz;
		tar -zxvf openssl-1.0.2u.tar.gz;
		cd openssl-1.0.2u;
		./config -fPIC --prefix=/usr/local/openssl-1.0.2u --openssldir=/usr/local/openssl-1.0.2u;
		make && make install;
		cd ..
		rm -rf openssl-1.0.2u openssl-1.0.2u.tar.gz
	fi;
	if [ ! -f /usr/local/curl-7.61.1/bin/curl ]; then
		wget $DOWNLOAD_FILE_URL/file/curl-7.61.1.tar.bz2 -O curl-7.61.1.tar.bz2;
		tar -xvf curl-7.61.1.tar.bz2;
		cd curl-7.61.1;
		./configure --prefix=/usr/local/curl-7.61.1 --with-ssl=/usr/local/openssl-1.0.2u --enable-ldap --enable-ldaps;
		make && make install;
		cd ..
		rm -rf curl-7.61.1 curl-7.61.1.tar.bz2
	fi;
fi;
}

if [ "$intallphpv" = "php52" ];then
	php_version="$PHP52"
	php_dir="tpl_php52"
elif [ "$intallphpv" = "php53" ];then
	php_version="$PHP53"
	php_dir="php53"
	install_curl
elif [ "$intallphpv" = "php54" ];then
	php_version="$PHP54"
	php_dir="php54"
	install_libicu
elif [ "$intallphpv" = "php55" ];then
	php_version="$PHP55"
	php_dir="php55"
elif [ "$intallphpv" = "php56" ];then
	php_version="$PHP56"
	php_dir="php56"
	install_libicu
	install_curl
elif [ "$intallphpv" = "php70" ];then
	php_version="$PHP70"
	php_dir="php70"
	install_libwebp
elif [ "$intallphpv" = "php71" ];then
	php_version="$PHP71"
	php_dir="php71"
elif [ "$intallphpv" = "php72" ];then
	php_version="$PHP72"
	php_dir="php72"
elif [ "$intallphpv" = "php73" ];then
	php_version="$PHP73"
	php_dir="php73"
	install_libicu
	install_libzip
elif [ "$intallphpv" = "php74" ];then
	php_version="$PHP74"
	php_dir="php74"
	install_libicu
	install_oniguruma
	install_libzip
elif [ "$intallphpv" = "php80" ];then
	php_version="$PHP80"
	php_dir="php80"
	install_libicu
	install_oniguruma
	install_libzip
elif [ "$intallphpv" = "php81" ];then
	php_version="$PHP81"
	php_dir="php81"
	install_libicu
	install_oniguruma
	install_libzip
else
	echo -e "————————————————————————————————————————————————————
未指定安装的PHP版本
————————————————————————————————————————————————————"
exit 1
fi

PREFIX="/vhs/kangle/ext/$php_dir"

phpv=""
if [ -f "${PREFIX}/bin/php" ]; then
	phpv=`"$PREFIX"/bin/php -v |grep "$php_version" -o`
fi

if [ "$php_version" = "$phpv" ]&&[ "$force_install" != "force" ]; then {
echo -e "————————————————————————————————————————————————————
检测到您已安装了 PHP-"$php_version" 
不需要重复再次安装
————————————————————————————————————————————————————"
exit 1
}
fi

file="php-${php_version}-${release}-${ARCH}.tar.bz2"
echo -e "正在下载$file"
wget -c $DOWNLOAD_FILE_URL/file/completed/$file -O $file
echo -e "正在解压缩文件"
tar -xjf $file
/vhs/kangle/bin/kangle -q
echo -e "正在安装文件"
rm -rf $PREFIX
mv -f $php_dir /vhs/kangle/ext/
rm -f $file
rm -rf /tmp/*
/vhs/kangle/bin/kangle
echo -e "————————————————————————————————————————————————————
SUCCESS：已成功安装PHP-$php_version
————————————————————————————————————————————————————"
