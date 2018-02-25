#! /bin/bash
SCRIPT_DIR="/root" #dropbox_uploader.sh的文件夹位置 
DROPBOX_DIR="/vps" #备份文件想要放在 Dropbox 下面的文件夹名称，如果不存在，脚本会自动创建 
OLD_DROPBOX_BAK=$(date -d -7day +"%Y.%m.%d").tar.gz #定义 Dropbox 的旧备份文件 
BACKUP_SRC="/etc/nginx/sites-available /var/www/" #想要备份的本地 VPS 上的文件，不同的目录用空格分开 
#如果安装的是 LNMP 一键包则备份 /usr/local/nginx/conf /home/wwwroot 
BACKUP_DST="/tmp" #暂时存放备份压缩文件的地方，一般用 /tmp 即可 
MYSQL_SERVER="localhost" #MySQL 服务器的地址，一般填这个本地地址即可 
MYSQL_USER="mysqluser" #MySQL 的用户名名称，一般是 root 或 admin 
MYSQL_PASS="mysqlpassword" #MySQL 用户的密码 

# 下面的一般不用改了 
NOW=$(date +"%Y.%m.%d")
DESTFILE="$BACKUP_DST/$NOW.tar.gz"
# 备份 MySQL 数据库并和其它备份文件一起压缩成一个文件 
mysqldump -u $MYSQL_USER -h $MYSQL_SERVER -p$MYSQL_PASS --all-databases > "$NOW-Databases.sql"
echo "数据库备份完成，打包网站数据中..."
tar cfzP "$DESTFILE" $BACKUP_SRC "$NOW-Databases.sql"
echo "所有数据打包完成，准备上传..."
# 用脚本上传到Dropbox 
$SCRIPT_DIR/dropbox_uploader.sh upload "$DESTFILE" "$DROPBOX_DIR/$NOW.tar.gz"

# 删除 Dropbox 中7天前的备份文件 
$SCRIPT_DIR/dropbox_uploader.sh delete "$DROPBOX_DIR/$OLD_DROPBOX_BAK"
# 删除本地的临时文件 
rm -f "$NOW-Databases.sql" "$DESTFILE"

echo "Backup Done!"
