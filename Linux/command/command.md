# Linux Command

## 常用命令

### 1、查看文件夹大小：

    #查看目录的大小
    du -sh  目录
    
    #查看文件大小
    du -sh  文件

### 2、查询文件夹内所有文件个数：

    ls -lR /root/find/ |grep "^-" |wc -l

### 3、查询文件夹内所有文件夹个数：

    ls -lR /root/find/ |grep "^d" |wc -l

### 4、查找文件：

    find */ -name configure-zfs.sh*
    
    grep -rin "文件名" *
    
    #包含特殊字符用单引号
    find / -name '*.sock'

### 5、更改软连接

    ln -snf [新的源文件或目录] [目标文件或目录]

### 6、rpm命令：

    #安装一个包
    rpm -ivh 包名
    
    #升级一个包
    rpm -Uvh 包名
    
    #卸载一个包
    rpm -e 包名
    
    #查找一个包
    rpm -qa 包名
    
    #强制安装某个文件夹下的所有rpm包，包括依赖
    rpm -Uvh --force --nodeps $wireless_path

### 7、下载rpm包：

    yum install yum-utils -y
    yumdownloader 包名

### 8、awk命令

    #awk输出最后一行
    awk 'END{print}'
    
    #awk输出最后3行
    awk 'END{print}' |tail -n 3

### 9、ping命令

    #设置每隔几秒发送一个ping包
    ping -i 10 192.168.9.101
    
    #指定次数后停止ping
    ping -c 5 192.168.9.101

### 10、文件夹创建：

    #多级文件夹下使用 -p 命令
    mkdir -p /root/testdir

### 11、从journalctl中导出日志

    #导出etcd的日志
    journalctl -u etcd > a.log

### 12、yum命令

    #安装rpm包
    yum localinstall percona-xtrabackup-24-2.4.4-1.el7.x86_64.rpm -y
    
    #显示已安装的软件包
    yum list installed
    
    #卸载软件包（已tomcat为例）
    yum remove tomcat
    
    #list中查找的安装包
    yum remove percona-xtrabackup-80.x86_64
    
    #列出依赖包
    yum deplist tomcat
    
    #显示软件包的描述信息和概要信息
    yum info tomcat
    
    #升级软件包
    yum update tomcat

### 13、tar命令

    #压缩文件
    tar -czvf archive.tar.gz /path/to/folder
    
    #解压文件
    tar -xzvf my_folder.tar.gz

### 14、yumdownloader命令

    #安装yumdownloader命令
    yum install yum-utils -y
    
    #下载x86架构下的rpm安装包的所有依赖到指定文件夹
    yumdownloader --arch=x86_64 --resolve --downloadonly --destdir=pciutils pciutils
    
    * --arch=x86_64 指定下载 x86_64 架构的包。如果要下载 i386 架构的包，则将 x86_64 替换为 i386。
    * --resolve 选项用于解析并下载包的所有依赖项。
    * --downloadonly 选项用于只下载 RPM 文件而不进行安装。
    * --destdir=/path/to/save 指定下载的包保存的目标文件夹路径。请将 /path/to/save 替换为你希望保存的文件夹路径。
    * <package_name> 是要下载的包的名称。将其替换为你想要下载的具体包的名称。

### 15、ethtool 命令

    #查看网口是否连接，Link detected: yes 表示连接，no表示未连接
    [root@localhost ~]# ethtool enp4s0
    Settings for enp4s0:
    Supported ports: [ TP ]
    Supported link modes:   10baseT/Half 10baseT/Full
                            100baseT/Half 100baseT/Full
                            1000baseT/Full
    Supported pause frame use: Symmetric
    Supports auto-negotiation: Yes
    Supported FEC modes: Not reported
    Advertised link modes:  10baseT/Half 10baseT/Full
                            100baseT/Half 100baseT/Full
                            1000baseT/Full
    Advertised pause frame use: Symmetric
    Advertised auto-negotiation: Yes
    Advertised FEC modes: Not reported
    Speed: 1000Mb/s
    Duplex: Full
    Port: Twisted Pair
    PHYAD: 1
    Transceiver: internal
    Auto-negotiation: on
    MDI-X: off (auto)
    Supports Wake-on: pumbg
    Wake-on: g
    Current message level: 0x00000007 (7)
                   drv probe link
    Link detected: yes

### 16、grep

    查找 8000 并排除多个文件夹
    grep --exclude-dir={log,logs,lib,python2.6,dist} -rlni "8000" /home/abcsecurity/iam/*

### 17、设置文件格式

    set fileformat=unix