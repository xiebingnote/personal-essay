# Linux+Nginx搭建Https步骤

## 一、准备工作

### 1.关闭防火墙

    (1)systemctl stop firewalld

    (2)systemctl disable firewalld

### 2.安装编译及库软件文件

    有网络环境下：
    yum -y install make zlib zlib-devel gcc-c++ libtool  openssl openssl-devel
    
    无网络环境下进入到下载好的rpm依赖包文件夹下，执行命令：
    rpm -Uvh *.rpm --nodeps --force
    
    ①　首先安装PCRE
    PCRE 作用是让 Nginx 支持 Rewrite 功能。
    下载 PCRE 安装包，下载地址： http://downloads.sourceforge.net/project/pcre/pcre/8.35/pcre-8.35.tar.gz
    
    ②　解压安装包进入目录并编译：
    (1)./configure

    (2)make && make install

    ③　查看pcre版本
    pcre-config --version

### 3.安装 Nginx

    下载 Nginx
    下载地址：http://nginx.org/download/nginx-1.6.2.tar.gz
    
    解压安装包进入目录并编译：
    (1)./configure --prefix=/usr/local/webserver/nginx --with-http_stub_status_module --with-http_ssl_module --with-pcre=/usr/local/src/pcre-8.35（pcre包所在的路径）

    (2)make

    (3)make install
    
    查看Nginx版本：
    /usr/local/webserver/nginx/sbin/nginx -v

## 二、Nginx配置

### 1.创建 Nginx 运行使用的用户 www：

    (1)/usr/sbin/groupadd www

    (2)/usr/sbin/useradd -g www www

### 2.配置nginx.conf ，将/usr/local/webserver/nginx/conf/nginx.conf替换为以下内容:

    user www www;
    worker_processes 2; #设置值和CPU核心数一致
    error_log /usr/local/webserver/nginx/logs/nginx_error.log crit; #日志位置和日志级别
    pid /usr/local/webserver/nginx/nginx.pid;
    #Specifies the value for maximum file descriptors that can be opened by this process.
    worker_rlimit_nofile 65535;
    events
    {
        use epoll;
        worker_connections 65535;
    }
    http
    {
        include mime.types;
        default_type application/octet-stream;
        log_format main  '$remote_addr - $remote_user [$time_local] "$request" '
        '$status $body_bytes_sent "$http_referer" '
        '"$http_user_agent" $http_x_forwarded_for';
        
        #charset gb2312;
        
        server_names_hash_bucket_size 128;
        client_header_buffer_size 32k;
        large_client_header_buffers 4 32k;
        client_max_body_size 8m;
        
        sendfile on;
        tcp_nopush on;
        keepalive_timeout 60;
        tcp_nodelay on;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
        fastcgi_buffer_size 64k;
        fastcgi_buffers 4 64k;
        fastcgi_busy_buffers_size 128k;
        fastcgi_temp_file_write_size 128k;
        gzip on;
        gzip_min_length 1k;
        gzip_buffers 4 16k;
        gzip_http_version 1.0;
        gzip_comp_level 2;
        gzip_types text/plain application/x-javascript text/css application/xml;
        gzip_vary on;
        
        #limit_zone crawler $binary_remote_addr 10m;
        #下面是server虚拟主机的配置
        server
        {
            listen 80;#监听端口
            server_name localhost;#域名
            index index.html index.htm index.php;
            root /usr/local/webserver/nginx/html;#站点目录
            location ~ .*\.(php|php5)?$
            {
                #fastcgi_pass unix:/tmp/php-cgi.sock;
                fastcgi_pass 127.0.0.1:9000;
                fastcgi_index index.php;
                include fastcgi.conf;
            }
            location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|ico)$
            {
                expires 30d;
                # access_log off;
            }
            location ~ .*\.(js|css)?$
            {
                expires 15d;
                # access_log off;
            }
            access_log off;
        }
    }

### 3.检查配置文件nginx.conf的正确性命令：

    /usr/local/webserver/nginx/sbin/nginx -t

### 4.启动 Nginx

    /usr/local/webserver/nginx/sbin/nginx

    注：如果执行启动命令后无输出，需再次执行一次启动命令

### 5.访问站点：

    从浏览器访问我们配置的站点ip，此时为http

## 三、自制证书

    证书生成的文件最好在同一个目录下，方便查找

### 1.制作CA私钥：

    openssl genrsa -des3 -out ca.key 2048

    注：需输入密码，请自行记下

### 2.制作CA根证书（公钥）：

    openssl req -new -x509 -days 365 -key ca.key -out ca.crt
    输出大概如下：
    Enter pass phrase for ca.key：输入ca.key的密码
    Country Name (2 letter code): 使用国际标准组织(ISO)国码格式，填写2个字母的国家代号。中国请填写CN。
    State or Province Name (full name): 省份，比如填写Shanghai
    Locality Name (eg, city): 城市，比如填写Shanghai
    Organization Name (eg, company): 组织单位，比如填写公司名称的拼音
    Organizational Unit Name (eg, section): 比如填写IT Dept
    Common Name (eg, your websites domain name): 使用SSL 加密的网站地址（请注意这里并不是单指您的域名，而是直接使用 SSL 的网站名称
    例如:pay.abc.com。 一个网站这里定义是： abc.com 是一个网站； www.abc.com 是另外一个网站；pay.abc.com 又是另外一个网站。 ）
    Email Address: 邮件地址，可以不填
    A challenge password: 可以不填
    An optional company name: 可以不填

### 3.制作网站的证书并用CA签名认证

    假设网站域名为www.example.com，生成com.example.com证书私钥：
    openssl genrsa -des3 -out www.example.com.pem 1024

### 4.制作解密后的www.example.com证书私钥：

    openssl rsa -in www.example.com.pem -out www.example.com.key

### 5.生成签名请求：

    openssl req -new -key www.example.com.pem -out www.example.com.csr
    输出大概如下：
    Enter pass phrase for ca.key：输入ca.key的密码
    Country Name (2 letter code): 使用国际标准组织(ISO)国码格式，填写2个字母的国家代号。中国请填写CN。
    State or Province Name (full name): 省份，比如填写Shanghai
    Locality Name (eg, city): 城市，比如填写Shanghai
    Organization Name (eg, company): 组织单位，比如填写公司名称的拼音
    Organizational Unit Name (eg, section): 比如填写IT Dept
    Common Name (eg, your websites domain name): 使用SSL 加密的网站地址
    Email Address: 邮件地址，可以不填
    A challenge password: 可以不填
    An optional company name: 可以不填

### 6.用CA进行签名：

    openssl ca -policy policy_anything -days 365 -cert ca.crt -keyfile ca.key -in www.example.com.csr
    -out www.example.com.crt

    注：执行签名时可能会出现如下问题：
    unable to open '/etc/pki/CA/index.txt'
    140653482149776:error:02001002:system library:fopen:No such file or directory:bss_file.c:402:fopen('
    /etc/pki/CA/index.txt','r')
    140653482149776:error:20074002:BIO routines:FILE_CTRL:system lib:bss_file.c:404:
    
    解决方法：
    (1)cd /etc/pki/CA/

    (2)touch index.txt

    (3)touch serial

    (4)echo "01" > serial

    然后回到之前的目录下，再次执行命令：openssl ca -policy policy_anything -days 365 -cert ca.crt -keyfile ca.key
    -in www.example.com.csr -out www.example.com.crt

## 四、配置虚拟机主机文件

### 1.找到nginx.conf文件所在目录

    cd /usr/webserver/nginx/conf/

### 2.编辑nginx.conf文件

    vim nginx.conf

    注释或者删除server中的内容，添加如下并保存：
    server {
        listen 80; #监听80端口
        server_name 10.150.30.129;
        #域名，根据实际情况填写                                                                                          
        rewrite ^(.*) https://$server_name$1 permanent; #80端口的http请求强制转换为https          
    }
    server {
        listen 443; #指定监听的端口
        server_name www.10.2.174.68.com; #域名，根据实际情况自行更改
        ssl on; #开启ssl支持
        ssl_certificate /root/key/www.10.2.174.68.com.crt; #网站签名路径
        ssl_certificate_key /root/key/www.10.2.174.68.com.key; #网站证书私钥路径
        ssl_session_timeout 5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2; #指定SSL服务器端支持的协议版本
        ssl_ciphers HIGH:!aNULL:!MD5; #指定加密算法
        ssl_prefer_server_ciphers on; #在使用SSLv3和TLS协议时指定服务器的加密算法要优先于客户端的加密算法
    
        # where the root here
        root /var/www; #默认访问路径为/var/www，如果配置其他路径运行并报错403Forbidden，自行在/var文件夹下创建www文件夹，并把要访问的html文件拷贝到/var/www文件夹下
        # what file to server as index
        index index.php index.html index.htm; #nginx会按照 index.php  index.html  index.htm 的先后顺序在默认访问的目录/var/www中查找文件。如果这三个文件都不存在，那么nginx就会返回403 Forbidden
    }

### 3.检验配置是否有错：

    /usr/local/webserver/nginx/sbin/nginx -t

### 4.如无错，让nginx.conf文件配置生效：

    /usr/local/webserver/nginx/sbin/nginx -s reload

### 5.重启nginx服务

    /usr/local/webserver/nginx/sbin/nginx

### 6.如果打开网页依旧为http，需先停止nginx的进程：

    ① 查看nginx进程：
    ps -ef | grep nginx
    
    ② 停止nginx：
    kill -QUIT 主进程号（root后为主进程号）
    例如：kill -QUIT 16391
    
    ③ 然后执行重启nginx服务命令
