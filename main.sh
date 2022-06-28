#!/bin/bash
files="/root/s-hell"
tmpfile="/root/hl-tmp"
release=`cat /etc/*release /etc/*version 2>/dev/null | grep -Eo '([0-9]{1,2}\.){1,3}' | cut -d '.' -f1 | head -1`;
source $files/config

if [ ! -d $tmpfile ] ; then
	mkdir $tmpfile;
fi;
function Installall(){
	cd $tmpfile
	wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
	wget -q $DOWNLOAD_URL/pre.sh -O pre.sh;sh pre.sh
}
function Installcdn(){
	cd $tmpfile
	wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
	wget -q $DOWNLOAD_URL/pre.sh -O pre.sh;sh pre.sh no
}
function Check(){
	cd $tmpfile
	wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
	wget -q $DOWNLOAD_URL/check.sh -O check.sh;sh check.sh
}
function Resql(){
	cd $tmpfile
	rm -rf $files/log/iset.log
	wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
	wget -q $DOWNLOAD_URL/sh/iset.sh -O iset.sh;sh iset.sh | tee $files/log/iset.log
}
function Upyum(){
	if [ "$release" == "8" ];then
		wget -q $DOWNLOAD_FILE_URL/repo/Centos-8.repo -O /etc/yum.repos.d/CentOS-Base.repo
		rpm -ivh $DOWNLOAD_FILE_URL/repo/epel-release-latest-8.noarch.rpm --nodeps --force
		wget -q $DOWNLOAD_FILE_URL/repo/epel-8.repo -O /etc/yum.repos.d/epel.repo
	elif [ "$release" == "7" ];then
		wget -q $DOWNLOAD_FILE_URL/repo/Centos-7.repo -O /etc/yum.repos.d/CentOS-Base.repo
		rpm -ivh $DOWNLOAD_FILE_URL/repo/epel-release-latest-7.noarch.rpm --nodeps --force
		wget -q $DOWNLOAD_FILE_URL/repo/epel-7.repo -O /etc/yum.repos.d/epel.repo
		mysql_repos_s=`ls /etc/yum.repos.d | grep mysql-community -i | wc -l`;
	elif [ "$release" == "6" ];then
		wget -q $DOWNLOAD_FILE_URL/repo/Centos-6.repo -O /etc/yum.repos.d/CentOS-Base.repo
		rpm -ivh $DOWNLOAD_FILE_URL/repo/epel-release-latest-6.noarch.rpm --nodeps --force
		wget -q $DOWNLOAD_FILE_URL/repo/epel-6.repo -O /etc/yum.repos.d/epel.repo
		mysql_repos_s=`ls /etc/yum.repos.d | grep mysql-community -i | wc -l`;
	fi
	yum clean all
}
function updatePackage()
{
	yum --exclude=kernel* update -y;
}
function Uninstall(){
	cd $tmpfile
	wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
	wget -q $DOWNLOAD_URL/uninstall.sh -O uninstall.sh;sh uninstall.sh
}
function Rephp(){
	cd $tmpfile
	wget -q $DOWNLOAD_URL/sh/rephp.sh -O rephp.sh;sh rephp.sh
}
function SetDNS(){
	echo -e "———————————————————————————
	\033[1mＫＡＮＧＬＥＳＯＦＴ\033[0m
	\033[32m修复系统DNS\033[0m
	1. 114DNS（国内服务器）
	2. 谷歌DNS（国外服务器）"
	read -p "请输入序号并回车:" YORN
	if [ "$YORN" = "2" ]; then
		echo -e "options timeout:1 attempts:1 rotate\nnameserver 8.8.8.8\nnameserver 8.8.4.4" >/etc/resolv.conf;
		echo "已经成功更改为谷歌DNS"
	else
		echo -e "options timeout:1 attempts:1 rotate\nnameserver 114.114.114.114\nnameserver 114.114.115.115" >/etc/resolv.conf;
		echo "已经成功更改为114DNS"
	fi
}
function Ntpdate(){
	\cp -a -r /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	service ntpd stop
	echo 'Synchronizing system time...'
	ntpdate 0.asia.pool.ntp.org
	echo "同步服务器时间成功"
}

function install_php(){
	cd $tmpfile
	rm -rf $files/log/php*.log
	wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
	wget -q $DOWNLOAD_URL/sh/phpc.sh -O phpc.sh
	sh phpc.sh 53 | tee $files/log/php53.log
	sh phpc.sh 54 | tee $files/log/php54.log
	sh phpc.sh 55 | tee $files/log/php55.log
	sh phpc.sh 56 | tee $files/log/php56.log
	sh phpc.sh 70 | tee $files/log/php70.log
	sh phpc.sh 71 | tee $files/log/php71.log
	sh phpc.sh 72 | tee $files/log/php72.log
	sh phpc.sh 73 | tee $files/log/php73.log
	if [ "$release" != "6" ]; then
	sh phpc.sh 74 | tee $files/log/php74.log
	sh phpc.sh 80 | tee $files/log/php80.log
	sh phpc.sh 81 | tee $files/log/php81.log
	fi
}
function install_php_force(){
	cd $tmpfile
	rm -rf $files/log/php*.log
	wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
	wget -q $DOWNLOAD_URL/sh/phpc.sh -O phpc.sh
	sh phpc.sh 53 force | tee $files/log/php53.log
	sh phpc.sh 54 force | tee $files/log/php54.log
	sh phpc.sh 55 force | tee $files/log/php55.log
	sh phpc.sh 56 force | tee $files/log/php56.log
	sh phpc.sh 70 force | tee $files/log/php70.log
	sh phpc.sh 71 force | tee $files/log/php71.log
	sh phpc.sh 72 force | tee $files/log/php72.log
	sh phpc.sh 73 force | tee $files/log/php73.log
	if [ "$release" != "6" ]; then
	sh phpc.sh 74 force | tee $files/log/php74.log
	sh phpc.sh 80 force | tee $files/log/php80.log
	sh phpc.sh 81 force | tee $files/log/php81.log
	fi
}
function install_phpc(){
	cd $tmpfile
	rm -f $files/log/php*.log
	wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
	wget -q $DOWNLOAD_URL/sh/php.sh -O php.sh
	sh php.sh php53| tee $files/log/php53.log
	sh php.sh php54| tee $files/log/php54.log
	sh php.sh php55| tee $files/log/php55.log
	sh php.sh php56| tee $files/log/php56.log
	sh php.sh php70| tee $files/log/php70.log
	sh php.sh php71| tee $files/log/php71.log
	sh php.sh php72| tee $files/log/php72.log
	sh php.sh php73| tee $files/log/php73.log
	if [ "$release" != "6" ]; then
	sh php.sh php74| tee $files/log/php74.log
	sh php.sh php80| tee $files/log/php80.log
	sh php.sh php81| tee $files/log/php81.log
	fi
}
function install_phpc_force(){
	cd $tmpfile
	rm -f $files/log/php*.log
	wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
	wget -q $DOWNLOAD_URL/sh/php.sh -O php.sh
	sh php.sh php53 force| tee $files/log/php53.log
	sh php.sh php54 force| tee $files/log/php54.log
	sh php.sh php55 force| tee $files/log/php55.log
	sh php.sh php56 force| tee $files/log/php56.log
	sh php.sh php70 force| tee $files/log/php70.log
	sh php.sh php71 force| tee $files/log/php71.log
	sh php.sh php72 force| tee $files/log/php72.log
	sh php.sh php73 force| tee $files/log/php73.log
	if [ "$release" != "6" ]; then
	sh php.sh php74 force| tee $files/log/php74.log
	sh php.sh php80 force| tee $files/log/php80.log
	sh php.sh php81 force| tee $files/log/php81.log
	fi
}
function install_ioncube(){
	cd $tmpfile
	rm -rf $files/log/ioncube.log
	wget -q $DOWNLOAD_URL/sh/ioncube.sh -O ioncube.sh;sh ioncube.sh | tee $files/log/ioncube.log
	rm -rf $tmpfile/*
}
function install_ixed(){
	cd $tmpfile
	rm -rf $files/log/ixed.log
	wget -q $DOWNLOAD_URL/sh/ixed.sh -O ixed.sh;sh ixed.sh | tee $files/log/ixed.log
	rm -rf $tmpfile/*
}
function phpini(){
	cd $tmpfile
	wget -q $DOWNLOAD_URL/sh/phpini.sh -O phpini.sh;sh phpini.sh
}
function install_mysql(){
	echo -e "———————————————————————————
	\033[1mＫＡＮＧＬＥＳＯＦＴ\033[0m
	\033[32mMySQL版本选择\033[0m
	1. MySQL 5.6(默认)
	2. MySQL 5.7
	3. MySQL 8.0
	a. 卸载当前MySQL版本"
	read -p "请输入序号并回车:" YORN
	if [ "$YORN" = "2" ]; then
		mysql_var="7";
	elif [ "$YORN" = "3" ]; then
		mysql_var="8";
	elif [ "$YORN" = "a" ]; then
		uninstall_mysql;
	else
		mysql_var="6";
	fi

	#设置MySQL密码
	mysql_root_password=""
	read -p "请输入您需要设置的MySQL密码(留空则随机生成):" mysql_root_password
	if [ "$mysql_root_password" = "" ]; then
	mysql_root_password=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 15`
	fi
	echo '[OK] Your MySQL password is:';
	echo $mysql_root_password;
	
	if [ "$release" == "8" ];then
		if [ "$mysql_var" = "8" ]; then
			rpm -ivh $DOWNLOAD_FILE_URL/repo/mysql80-community-release-el8.noarch.rpm --nodeps --force
			wget -q $DOWNLOAD_FILE_URL/repo/mysql-community-8.repo -O /etc/yum.repos.d/mysql-community.repo
		fi
	else
		if [ "$mysql_var" = "7" ]; then
			wget -q $DOWNLOAD_FILE_URL/repo/mysql-community-7.repo -O /etc/yum.repos.d/mysql-community.repo
		elif [ "$mysql_var" = "8" ]; then
			wget -q $DOWNLOAD_FILE_URL/repo/mysql-community-8.repo -O /etc/yum.repos.d/mysql-community.repo
		else
			wget -q $DOWNLOAD_FILE_URL/repo/mysql-community.repo -O /etc/yum.repos.d/mysql-community.repo
		fi
	fi
	yum clean all

	cd $tmpfile
	rm -rf $files/log/sql.log
	wget -q $DOWNLOAD_URL/sh/sql.sh -O sql.sh;sh sql.sh $mysql_var $mysql_root_password | tee $files/log/sql.log
}
function uninstall_mysql()
{
	read -p "卸载后将清空数据库，请确认已做好数据备份，输入y并回车以继续卸载:" UNINSTALL
	if [[ "${UNINSTALL,,}" = "y" ]]; then
		echo '正在停止MySQL进程...';
		service mysqld stop
		killall mysqld
		echo '正在卸载MySQL...';
		yum -y remove mysql mysql-server mysql-libs mysql-devel mysql-common mysql-client mysql-client-plugins;
		rm -rf /var/lib/mysql;
		rm -rf /home/mysql;
		echo 'MySQL卸载成功！';
		exit 0;
	else
		echo '已取消操作';
		exit 0;
	fi;
}
function install_kangle(){
	wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
	source $files/iver
	cd $tmpfile
	echo -e "———————————————————————————
	\033[1mＫＡＮＧＬＥＳＯＦＴ\033[0m
	\033[32mKangle版本选择\033[0m
	（极速安装均为商业版,经典版均不支持CentOS 7）
	1. 极速安装 Kangle 3.5.21 最新版 
	2. 编译安装 Kangle 3.5.21 开发版
	3. 极速安装 Kangle 3.5.14 经典版
	4. 极速安装 Kangle 3.5.10 经典版
	5. 极速安装 Kangle 3.4.8 经典版
	6. 编译安装 Kangle 3.4.8 经典版"
	read -p "请输入序号并回车:" YORN
	if [ "$YORN" = "2" ]; then
		kangle_ver="$KANGLE_VERSION";
		rm -rf $files/log/kangle.log
		wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
		wget -q $DOWNLOAD_URL/sh/kangle.sh -O kangle.sh;sh kangle.sh $kangle_ver 0 | tee $files/log/kangle.log
	elif [ "$YORN" = "3" ]; then
		kangle_ver="3.5.14.13";
		rm -rf $files/log/kangle.log
		wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
		wget -q $DOWNLOAD_URL/sh/kangle.sh -O kangle.sh;sh kangle.sh $kangle_ver 1 | tee $files/log/kangle.log
	elif [ "$YORN" = "4" ]; then
		kangle_ver="$KANGLE_ENT_VERSION";
		rm -rf $files/log/kangle.log
		wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
		wget -q $DOWNLOAD_URL/sh/kangle.sh -O kangle.sh;sh kangle.sh $kangle_ver 1 | tee $files/log/kangle.log
	elif [ "$YORN" = "5" ]; then
		kangle_ver="$KANGLE_OLD_VERSION";
		rm -rf $files/log/kangle.log
		wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
		wget -q $DOWNLOAD_URL/sh/kangle.sh -O kangle.sh;sh kangle.sh $kangle_ver 1 | tee $files/log/kangle.log
	elif [ "$YORN" = "6" ]; then
		kangle_ver="$KANGLE_OLD_VERSION";
		rm -rf $files/log/kangle.log
		wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
		wget -q $DOWNLOAD_URL/sh/kangle.sh -O kangle.sh;sh kangle.sh $kangle_ver 0 | tee $files/log/kangle.log
	else
		kangle_ver="$KANGLE_NEW_VERSION";
		rm -rf $files/log/kangle.log
		wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
		wget -q $DOWNLOAD_URL/sh/kangle.sh -O kangle.sh;sh kangle.sh $kangle_ver 1 | tee $files/log/kangle.log
	fi
}
function install_easypanel(){
	cd $tmpfile
	rm -rf $files/log/ep.log
	wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
	wget -q $DOWNLOAD_URL/sh/ep.sh -O ep.sh;sh ep.sh force | tee $files/log/ep.log
}
function install_phpmyadmin(){
	cd $tmpfile
	rm -rf $files/log/pm.log
	wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
	wget -q $DOWNLOAD_URL/sh/pm.sh -O pm.sh;sh pm.sh | tee $files/log/pm.log
}
function setvhms(){
	wget -q $DOWNLOAD_URL/sh/vhms.sh -O vhms.sh;sh vhms.sh
}
function Update(){
	cd $tmpfile
	#links="http://kangle.dj1313.com"
	wget -q $DOWNLOAD_URL/config -O $files/config
	wget -q $DOWNLOAD_URL/main.sh -O main.sh;
	cp -f main.sh /usr/bin/kanglesh
	chmod 755 /usr/bin/kanglesh
	echo "更新成功"
	sh main.sh
	exit 0;
}
function flowcron(){
	sed -i 's/tpl_php52/php56/g' /etc/cron.d/ep_sync_flow
	sed -i 's/php53/php56/g' /etc/cron.d/ep_sync_flow
	/etc/init.d/crond restart
	echo -e "修改保存成功
"
}
function Easypanel_view(){
	cd $tmpfile
	wget -q $DOWNLOAD_URL/sh/view.sh -O view.sh;sh view.sh
}
function Resetpwd(){
	clear
	read -p "请输入Kangle管理员-新用户名：" ep_admin
	echo -e "\033[44;37m 你输入Kangle管理员-新用户名是：$ep_admin \033[0m"
	read -p "请输入Kangle管理员-新密码：" ep_passwd
	echo -e "\033[44;37m 你输入Kangle管理员-新密码是：$ep_passwd \033[0m"
	# passwdmd5=` echo -n '$ep_passwd'|md5sum|cut -d ' ' -f1 `
	nl /vhs/kangle/etc/config.xml | sed -i "s/admin user='.*' password='.*' a/admin user='$ep_admin' password='$ep_passwd' a/g" /vhs/kangle/etc/config.xml
	service kangle restart
	echo "Kangle管理员账户&密码已修改成功"
}
function Clean(){
	echo "正在执行清理垃圾任务，执行时间由文件数量决定，请耐心等待。。。"
	rm -rf /vhs/kangle/tmp/*
	rm -rf /vhs/kangle/var/*.log
	rm -rf /tmp
	mkdir /tmp
	chmod -R 777 /tmp
	/vhs/kangle/bin/kangle --reboot

	echo "清理垃圾文件释放空间执行完毕！"
}
function Safedog(){
	echo -e "———————————————————————————
	\033[1mＫＡＮＧＬＥＳＯＦＴ\033[0m
	\033[32m安全狗Linux版\033[0m
	1. 安装
	2. 卸载"
	read -p "请输入序号并回车:" YORN
	if [ "$YORN" = "1" ]; then
		cd $tmpfile
		yum -y install mlocate lsof pciutils dmidecode psmisc
		if [ ! -f /usr/bin/python ]; then
			if [ ! -f /usr/bin/python3 ]; then
				yum -y install python3
			fi;
			ln -s /usr/bin/python3 /usr/bin/python
		fi;
		wget http://download.safedog.cn/safedog_linux64.tar.gz -O safedog_linux64.tar.gz
		tar xvzf safedog_linux64.tar.gz
		cd safedog_an_linux64_*
		chmod +x *.py
		./install.py
		/usr/bin/sdcmd webflag 0
		/usr/bin/sdcmd twreuse 1
		/usr/bin/sdcmd sshddenyflag 1
		echo "安全狗Linux版安装完毕！"
		echo "执行以下命令加入服云：sdcloud -u 你的用户名"
	else
		cd $tmpfile
		cd safedog_an_linux64_*
		./uninstall.py
	fi
}

function BBR()
{
	echo -e "———————————————————————————
	\033[1mＫＡＮＧＬＥＳＯＦＴ\033[0m
	\033[32mBBR TCP加速\033[0m
	1. 安装 BBR 内核
	2. 开启 BBR TCP 加速"
	read -p "请输入序号并回车:" YORN
	if [ "$YORN" = "1" ]; then
		if [ "$release" -eq "6" ]; then
			rpm_kernel_url="https://dl.lamp.sh/files/"
			if test `arch` = "x86_64"; then
				rpm_kernel_name="kernel-ml-4.18.20-1.el6.elrepo.x86_64.rpm"
				rpm_kernel_devel_name="kernel-ml-devel-4.18.20-1.el6.elrepo.x86_64.rpm"
			else
				rpm_kernel_name="kernel-ml-4.18.20-1.el6.elrepo.i686.rpm"
				rpm_kernel_devel_name="kernel-ml-devel-4.18.20-1.el6.elrepo.i686.rpm"
			fi
			wget -c -t3 -T60 -O ${rpm_kernel_name} ${rpm_kernel_url}${rpm_kernel_name};
			[ $? -ne 0 ] && echo "Download ${rpm_kernel_name} failed, please check it." && exit 1;
			wget -c -t3 -T60 -O ${rpm_kernel_devel_name} ${rpm_kernel_url}${rpm_kernel_devel_name}
			[ $? -ne 0 ] && echo "Download ${rpm_kernel_devel_name} failed, please check it." && exit 1;
			rpm -ivh ${rpm_kernel_name};
			rpm -ivh ${rpm_kernel_devel_name};
			rm -f ${rpm_kernel_name} ${rpm_kernel_devel_name};
			[ ! -f "/boot/grub/grub.conf" ] && echo "/boot/grub/grub.conf not found, please check it." && exit 1;
			sed -i 's/^default=.*/default=0/g' /boot/grub/grub.conf
			yum -y remove kernel kernel-tools
		elif [ "$release" -eq "7" ]; then
			rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
			yum -y install https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
			yum -y --enablerepo=elrepo-kernel install kernel-ml kernel-ml-devel
			yum install -y grub2-tools
			INS_OK=`awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg | grep elrepo. | grep -i -v debug | grep -i -v rescue | cut -d' ' -f1`
			if [ -z ${INS_OK} ]; then
				echo "BBR内核安装失败";
				exit 1;
			fi
			grub2-set-default ${INS_OK}
			yum -y remove kernel kernel-tools
		elif [ "$release" -eq "8" ]; then
			echo "———————————————————————————
提示：CentOS 8 自带 BBR，直接选择开启即可！";
			BBR;
		else
			echo "你当前的操作系统暂不支持";
			exit 1;
		fi
		read -p "BBR 内核安装成功，重启后请重新运行脚本选开启，是否现在重启？(y/n)" is_reboot
		if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
			reboot
		else
			exit 0
		fi
	else
		if [ "$release" -eq "6" ]; then
			if [ `grep -c ".elrepo." /boot/grub/grub.conf` -eq '0' ];then
				echo "———————————————————————————
提示：请先安装 BBR 内核！";
				BBR;
				exit;
			fi
		elif [ "$release" -eq "7" ]; then
			INS_OK=`awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg | grep elrepo. | grep -i -v debug | grep -i -v rescue | cut -d' ' -f1`
			if [ -z ${INS_OK} ]; then
				echo "———————————————————————————
提示：请先安装 BBR 内核！";
				BBR;
				exit;
			fi
		fi
		
		sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
		sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
		echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
		sysctl -p
		lsmod | grep bbr
		echo -e "BBR TCP 加速启动成功！"
		exit;
	fi
}
function Auto_Swap()
{
	swap=$(free |grep Swap|awk '{print $2}')
	if [ "${swap}" -gt 1 ];then
		echo "Swap total sizse: $swap";
		return;
	fi
	swapFile="/home/swap"
	dd if=/dev/zero of=$swapFile bs=1M count=1025
	mkswap -f $swapFile
	swapon $swapFile
	echo "$swapFile    swap    swap    defaults    0 0" >> /etc/fstab
	swap=`free |grep Swap|awk '{print $2}'`
	if [ $swap -gt 1 ];then
		echo "Swap total sizse: $swap";
		return;
	fi
	
	sed -i "/\/home\/swap/d" /etc/fstab
	rm -f $swapFile
}
function Ipset(){
	echo -e "———————————————————————————
	\033[1mＫＡＮＧＬＥＳＯＦＴ\033[0m
	\033[32mKangle配合ipset防CC\033[0m
	1. 安装并配置ipset防CC
	2. 取消配置ipset防CC"
	read -p "请输入序号并回车:" YORN
	if [ "$YORN" = "1" ]; then
		if [ "$release" -eq "7" ]; then
			yum install -y iptables iptables-services
			systemctl stop firewalld
			systemctl disable firewalld
			chmod +x /etc/rc.d/rc.local
		fi
		yum install -y ipset
		ipset create kangle hash:ip hashsize 4096 maxelem 1000000
		echo "/usr/sbin/ipset create kangle hash:ip hashsize 4096 maxelem 1000000" >> /etc/rc.d/rc.local
		iptables -I INPUT -m set --match-set kangle src -p tcp -m multiport --destination-port 80,81,443,3312,3313 -j DROP
		service iptables save
		service iptables restart
		wget -q $DOWNLOAD_URL/config_file/iptables.xml -O /vhs/kangle/ext/iptables.xml
		/vhs/kangle/bin/kangle --reboot
		echo "ipset防CC安装并配置成功"
	else
		rm -f /vhs/kangle/ext/iptables.xml
		/vhs/kangle/bin/kangle --reboot
		ipset flush
		echo "ipset防CC取消配置成功"
	fi
}

function Fail2ban(){
	echo -e "———————————————————————————
	\033[1mＫＡＮＧＬＥＳＯＦＴ\033[0m
	\033[32mFail2ban防SSH暴力破解\033[0m
	1. 安装并配置Fail2ban
	2. 取消配置Fail2ban
	3. 查看Fail2ban运行状态"
	read -p "请输入序号并回车:" YORN
	if [ "$YORN" = "1" ]; then
		yum install -y fail2ban
		rm -f /etc/fail2ban/jail.d/00-firewalld.conf
		wget -q $DOWNLOAD_URL/config_file/jail.local -O /etc/fail2ban/jail.d/jail.local
		if [ "$release" -eq "6" ]; then
			chmod +x /etc/init.d/fail2ban
			chkconfig --add fail2ban
			chkconfig fail2ban on
			service fail2ban start
		else
			systemctl enable fail2ban
			systemctl start fail2ban
		fi
		echo "Fail2ban安装并配置成功"
	elif [ "$YORN" = "2" ]; then
		if [ "$release" -eq "6" ]; then
			service fail2ban stop
			chkconfig fail2ban off
			chkconfig --del fail2ban
		else
			systemctl stop fail2ban
			systemctl disable fail2ban
		fi
		service iptables restart
		echo "Fail2ban配置成功"
	else
		fail2ban-client status ssh-iptables
	fi
}

function XtraBackup()
{
	xtra_version="2.4.24-1";
	if [ "$release" -eq "8" ]; then
		xtra_attr="el8.x86_64";
	elif [ "$release" -eq "7" ]; then
		xtra_attr="el7.x86_64";
	elif test `arch` = "x86_64"; then
		xtra_attr="el6.x86_64";
	else
		xtra_attr="el6.i686";
	fi
	wget -O percona-xtrabackup-24-${xtra_version}.${xtra_attr}.rpm $DOWNLOAD_FILE_URL/file/percona-xtrabackup-24-${xtra_version}.${xtra_attr}.rpm
	yum -y install percona-xtrabackup-24-${xtra_version}.${xtra_attr}.rpm
	rm -f percona-xtrabackup-24-${xtra_version}.${xtra_attr}.rpm
}

function cdnbest()
{
	rm -rf $files/log/cdnbest.log
	wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
	wget -q $DOWNLOAD_URL/sh/cdnbest.sh -O cdnbest.sh;sh cdnbest.sh | tee $files/log/cdnbest.log
}

function AutoDisk()
{
	wget -q $DOWNLOAD_URL/sh/auto_disk.sh -O auto_disk.sh;sh auto_disk.sh
}

function InstallRedis()
{
	rm -rf $files/log/redis.log
	wget -q $DOWNLOAD_URL/lg/install_ver.h -O $files/iver
	wget -q $DOWNLOAD_URL/sh/redis.sh -O redis.sh;sh redis.sh | tee $files/log/redis.log
}

function mysql_ini(){
	cd $tmpfile
	echo -e "———————————————————————————
	\033[1mＫＡＮＧＬＥＳＯＦＴ\033[0m
	\033[32mMysql配置文件(my.cnf)选择\033[0m
	（更改配置文件之后会重启数据库）
	1. 适合1~2G内存的服务器（默认）
	2. 适合4G内存的服务器
	3. 适合8G内存的服务器
	4. 适合16G内存的服务器"
	read -p "请输入序号并回车:" YORN
	if [ "$YORN" = "2" ]; then
		MYNUM="2";
	elif [ "$YORN" = "3" ]; then
		MYNUM="3";
	elif [ "$YORN" = "4" ]; then
		MYNUM="4";
	else
		MYNUM="";
	fi
	mysql_ver=`cat /etc/mysql_ver`
	if [ "$mysql_ver" = "8" ]; then
		wget -q $DOWNLOAD_URL/config_file/mysql8.0/my${MYNUM}.cnf -O /etc/my.cnf
	elif [ "$mysql_ver" = "7" ]; then
		wget -q $DOWNLOAD_URL/config_file/mysql5.7/my${MYNUM}.cnf -O /etc/my.cnf
	else
		wget -q $DOWNLOAD_URL/config_file/mysql5.6/my${MYNUM}.cnf -O /etc/my.cnf
	fi
	service mysqld restart
}

function InstallPHP(){
clear
echo -e "————————————————————————————————————————————————————
	\033[1mＫＡＮＧＬＥＳＯＦＴ\033[0m
	\033[32mKangle一键脚本-单独安装PHP\033[0m
	说明：以下内容已经包含在'安装全部'里面
————————————————————————————————————————————————————
1. ◎ 自动安装/更新 PHP5.3-8.1（极速安装）
2. ◎ 自动安装/更新 PHP5.3-8.1（编译安装）
3. ◎ 重新安装 PHP5.3-8.1（极速安装）
4. ◎ 重新安装 PHP5.3-8.1（编译安装）
5. ◎ 自动更新 ionCube组件
6. ◎ 自动更新 SG11组件
7. ◎ 重置全部PHP版本php.ini文件
0. ◎ 返回上一级菜单"
read -p "请输入序号并回车：" num
case "$num" in
[1] ) (install_phpc);;
[2] ) (install_php);;
[3] ) (install_phpc_force);;
[4] ) (install_php_force);;
[5] ) (install_ioncube);;
[6] ) (install_ixed);;
[7] ) (phpini);;
[0] ) (Install);;
*) (InstallPHP);;
esac
}

function Tools(){
clear
echo -e "————————————————————————————————————————————————————
	\033[1mＫＡＮＧＬＥＳＯＦＴ\033[0m
	\033[32mKangle一键脚本-Linux工具箱\033[0m
————————————————————————————————————————————————————
1. ◎ 重置系统Yum源
2. ◎ 修改系统DNS设置
3. ◎ 同步服务器时间
4. ◎ 清理垃圾文件释放空间
5. ◎ 安全狗Linux版
6. ◎ BBR TCP加速
7. ◎ 初始化Swap虚拟内存（适合小内存机器）
8. ◎ Kangle配合ipset防CC
9. ◎ 安装XtraBackup2.4
10. ◎ Mysql配置文件更换
11. ◎ 更新系统yum软件包
12. ◎ 数据盘自动分区并挂载到/home
13. ◎ 安装Redis Server
14. ◎ Fail2ban防SSH暴力破解
0. ◎ 返回上一级菜单"
read -p "请输入序号并回车：" num
case "$num" in
1) (Upyum);;
2) (SetDNS);;
3) (Ntpdate);;
4) (Clean);;
5) (Safedog);;
6) (BBR);;
7) (Auto_Swap);;
8) (Ipset);;
9) (XtraBackup);;
10) (mysql_ini);;
11) (updatePackage);;
12) (AutoDisk);;
13) (InstallRedis);;
14) (Fail2ban);;
0) (Init);;
*) (Install);;
esac
}

function Install(){
clear
echo -e "————————————————————————————————————————————————————
	\033[1mＫＡＮＧＬＥＳＯＦＴ\033[0m
	\033[32mKangle一键脚本-单独安装\033[0m
	说明：以下内容已经包含在'安装全部'里面
————————————————————————————————————————————————————
1. ◎ 安装/更新 Kangle 组件
2. ◎ 安装/更新 Easypanel 组件
3. ◎ 安装/更新多版本 PHP 组件
4. ◎ 重新安装 MySQL5.6/5.7/8.0
5. ◎ 设置VHMS计划任务
6. ◎ 修复EP流量统计计划任务
7. ◎ 安装 cdnbest 最新版
8. ◎ 安装 phpMyAdmin
0. ◎ 返回上一级菜单"
read -p "请输入序号并回车：" num
case "$num" in
[1] ) (install_kangle);;
[2] ) (install_easypanel);;
[3] ) (InstallPHP);;
[4] ) (install_mysql);;
[5] ) (setvhms);;
[6] ) (flowcron);;
[7] ) (cdnbest);;
[8] ) (install_phpmyadmin);;
[0] ) (Init);;
*) (Install);;
esac
}

function Init(){
clear
echo -e "————————————————————————————————————————————————————
	\033[1mＫＡＮＧＬＥＳＯＦＴ\033[0m
	\033[32mKangle一键脚本-主菜单-Ver.20220324\033[0m
	说明：kanglesh命令可随时打开当前菜单
————————————————————————————————————————————————————
1. ◎ 安装全部 Kangle/Easypanel/PHP/Mysql
2. ◎ 安装全部 Kangle/Easypanel/PHP (CDN专用)
3. ◎ 单独安装/更新组件
4. ◎ 更换 Easypanel 模板
5. ◎ 重置MySQL数据库密码
6. ◎ 重置Kangle后台登录密码
7. ◎ 自定义卸载PHP版本
8. ◎ 完全卸载Kangle
9. ◎ Linux工具箱
a. ◎ 更新当前脚本
0. ◎ 退出安装"
read -p "请输入序号并回车：" num
case "$num" in
[1] ) (Installall);;
[2] ) (Installcdn);;
[3] ) (Install);;
[4] ) (Easypanel_view);;
[5] ) (Resql);;
[6] ) (Resetpwd);;
[7] ) (Rephp);;
[8] ) (Uninstall);;
[9] ) (Tools);;
[a] ) (Update);;
[0] ) (exit);;
*) (Init);;
esac
}

Init
