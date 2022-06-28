#!/bin/bash
files="/root/s-hell"
PREFIX="/vhs/kangle"
source $files/config
source $files/iver

OS="6"
if [ -f /usr/bin/systemctl ] ; then
        OS="7"
        if [ -f /usr/bin/dnf ] ; then
                OS="8"
        fi
fi
if test `arch` != "x86_64"; then
	echo "only support arch x86_64..."
	exit 1
fi
ARCH="$OS-x64"

#https://www.cdnbest.com/download/cdnbest/cdnbest-4.6.4-8-x64.tar.gz
URL="$DOWNLOAD_FILE_URL/file/completed/cdnbest-$CDNBEST_VERSION-$ARCH.tar.gz"
wget $URL -O cdnbest.tar.gz
ret=$?
if [ $ret != 0 ] ; then
	echo "cann't download file"
	exit $ret
fi
tar xzf cdnbest.tar.gz
service cdnbest stop
cd cdnbest
\cp bin $PREFIX -a
\cp init/cdnbest /etc/init.d/
chmod 700 /etc/init.d/cdnbest
if [ ! -f /etc/rc3.d/S67cdnbest ] ;then
	ln -s /etc/init.d/cdnbest /etc/rc3.d/S67cdnbest
fi
if [ ! -f /etc/rc5.d/S67cdnbest ] ;then
	ln -s /etc/init.d/cdnbest /etc/rc5.d/S67cdnbest
fi
if [ -f /usr/bin/systemctl ] ; then
	/usr/bin/systemctl daemon-reload
fi
service cdnbest start

cd ..
rm -rf cdnbest cdnbest.tar.gz
if [ $? != 0 ] ; then
	echo "cdnbest-$CDNBEST_VERSION 安装失败！"
	exit $ret
else
	echo "cdnbest-$CDNBEST_VERSION 安装成功！"
fi
