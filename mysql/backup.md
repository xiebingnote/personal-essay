# Backup MySQL Database

## mysql 备份

### 1、数据备份

    执行mysql命令，使用-u，-p时，-p连接服务器时使用的密码。如果使用短选项形式(-p)，不能在选项和密码之间有一个空格。如果在命令行中，忽略了--password或-p选项后面的密码值，将提示输入一个
    #Pword为密码
    mysqldump -u root -pPword -h 127.0.0.1 test > a.sql

#### 备份脚本：

    #!bin/bash
    user="root"
    passwd="123456"
    dbname="testdb"
    datadir="/var/lib/backup/mysql"
    backupname="backup.sql"
    
    mysqldump -u $user -p$passwd -h 127.0.0.1 --opt $dbname > $datadir/$backupname

### 2、mysqldump导出数据库报错：mysqldump: Got error: 2002: Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2) when trying to connect

#### 解决方法：

    mysqldump的连接方法与mysql命令无异，只需要指定导出的数据库即可：
    #ip地址最好写127.0.0.1
    mysqldump -h{ip地址} -P{端口号} -u{用户名} -p{密码} --databases {数据库1} {数据库2} {数据库3}等等 > {导出文件路径}
    导出只要带上ip地址和端口号，就不会出现上述报错，完全没必要去改mysql.sock这个文件。