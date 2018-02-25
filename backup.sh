#! /bin/bash

LOCAL_BAK_DIR="/root/backup"  #备份文件到指定位置 
MYSQL_SERVER="localhost"      #MySQL 服务器的地址，一般是本地地址 
MYSQL_USER="mysqluser"        #MySQL 的用户名名称，一般是 root 或 admin 
MYSQL_PASS="mysqlpassword"    #MySQL 用户的密码 

echo "Start Backup"

# 备份并打包 MySQL 数据库 
mysqldump -u $MYSQL_USER -h $MYSQL_SERVER -p $MYSQL_PASS --all-databases > /tmp/dbbak.sql
tar zcvf $LOCAL_BAK_DIR/MySQL.tar.gz -P /tmp/dbbak.sql
rm -f /tmp/dbbak.sql
echo "Database backup success..."

# 备份并打包网站文件 
tar zcfP $LOCAL_BAK_DIR/web.tar.gz /var/www/
tar zcfP $LOCAL_BAK_DIR/nginx.tar.gz /etc/nginx/sites-available
#如果安装的是 LNMP 一键包则备份 /usr/local/nginx/conf /home/wwwroot 
echo "Web files backup success..."

# 备份结束 
echo "Backup Done! "$(date +"%Y.%m.%d") >> /root/backup.log
