# lograte

## 日志分割

### linux服务自带lograte命令，命令格式如下：

    logrotate [OPTION...] <configfile>
    -d, --debug ：debug模式，测试配置文件是否有错误。
    -f, --force ：强制转储文件。
    -m, --mail=command ：压缩日志后，发送日志到指定邮箱。
    -s, --state=statefile ：使用指定的状态文件。
    -v, --verbose ：显示转储过程。

### 添加配置文件

    配置文件路径：/etc/lograte.cnf
    自定义添加配置：/etc/lograte.d/自定义文件

    #文件
    /var/log/127.0.0.1/nsqlookupd.log
    /var/lib/etcd/log/etcd.log
    /var/log/127.0.0.1/elasticsearch.log

    #文件夹
    /var/lib/etcd/log
    {
        rotate 5
        missingok
        notifempty
        maxsize 100M
        weekly
        dateext
        create 0600 root root
    }

### 执行命令

    添加完之后，执行命令：
    logrotate -vf /etc/logrotate.d/自定义文件
    