# 【玩转Lighthouse】轻量一键搭建kangle自建CDN节点  


#Kangle脚本简介
#Kangle一键脚本，是一款可以一键安装Kangle+Easypanel+Mysql集合的Linux脚本。 脚本本身集成：PHP5.3～PHP8.0、MYSQL5.6，支持极速安装和编译安装2种模式，支持CDN专属安装模式。同时也对#Easypanel面板进行了大量优化。

#脚本特点
自带Kangle商业版最新版本免费使用
支持EP前台自由切换PHP5.3-8.1
安装前可选MySQL5.6、5.7、8.0版本
预先设置各PHP版本PHP.ini安全问题
安装前可自定义数据库密码，避免安装完成后再设置的麻烦
支持自定义403.404.503.504等错误页面
脚本中可切换其它几套EP用户后台模板
脚本中集成Linux工具箱，可一键更换Yum源、更换DNS、设置Swap、同步时间、清理垃圾等
修改kangle二进制文件以提升错误页加载速度  

#EP基于原版的优化内容
0.EP源码全解密并升级smarty框架
1.SSL证书可同步到cdn节点
2.SSL配置页面新增"HTTP跳转到HTTPS"选项
3.SSL配置页面新增"开启HTTP2"选项
4.CDN主机可以给单个域名设置SSL证书
5.增加独立的PHP版本切换页面
6.EP管理员后台增加选项：默认PHP版本、允许域名泛绑定
7.修复带有空格的文件名无法解压和重命名的问题
9.CDN绑定域名可以自定义回源协议，增加tcp四层转发
10.优化防CC设置页面，支持设置IP白名单
11.清除缓存页面支持批量清除
12.支持设置url黑名单
13.绑定域名页面新增编辑按钮
* EP升级方法：脚本主菜单选择单独安装/更新组件，然后选择更新Easypanel  

#注意事项
本脚本支持CentOS 6.x/CentOS 7.x/CentOS 8.x系统（其中CentOS6不支持安装PHP7.4和PHP8.0）

#Kangle安装方式
#请复制以下指令到ssh连接软件粘贴执行  

yum -y install wget;wget https://raw.githubusercontent.com/xu5343/kangle/main/start;sh start


