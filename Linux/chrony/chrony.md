# chrony 时钟同步工具

## 安装步骤

### 1：安装命令

    yum install chrony -y

### 2：配置文件说明：

    # Use public servers from the pool.ntp.org project.
    # Please consider joining the pool (http://www.pool.ntp.org/join.html).
    # 配置NTP服务器
    server 0.centos.pool.ntp.org iburst
    server 1.centos.pool.ntp.org iburst
    server 2.centos.pool.ntp.org iburst
    server 3.centos.pool.ntp.org iburst
    # Record the rate at which the system clock gains/losses time.


    # 记录系统时钟获得/丢失时间的速率至drift文件中
    driftfile /var/lib/chrony/drift


    # Allow the system clock to be stepped in the first three updates
    # if its offset is larger than 1 second.
    # 默认情况下，chronyd通过减慢或加快时钟速度来逐渐调整时钟。如果时钟与实际时间偏差太大，则需要很长时间才能纠正错误。这种方法叫做步进时钟（时间跳变）。
    # 此处表示如果调整值大于1000秒，则这将使系统时钟步进，但仅在前十个时钟更新中。
    makestep 1000 10


    # Enable kernel synchronization of the real-time clock (RTC).
    # 启用RTC（实时时钟）的内核同步
    rtcsync


    # Enable hardware timestamping on all interfaces that support it.
    #hwtimestamp *


    # Increase the minimum number of selectable sources required to adjust
    # the system clock.
    #minsources 2


    # Allow NTP client access from local network.
    # 只允许192.168.网段的客户端进行时间同步
    #allow 192.168.0.0/16


    # Serve time even if not synchronized to a time source.
    # NTP服务器不可用时，采用本地时间作为同步标准
    #local stratum 10


    # Specify file containing keys for NTP authentication.
    # 指定包含NTP验证密钥的文件
    #keyfile /etc/chrony.keys


    # Specify directory for log files.
    # 指定日志文件的目录
    logdir /var/log/chrony


    # Select which information is logged.
    # 将对系统增益或损耗率的估计值以及所做的任何转换记录的更改记录到名为的文件中tracking.log。
    #log measurements statistics tracking


    # 其他未在默认配置文件的配置项
    # 在第一次时钟更新之后，chronyd将检查每次时钟更新的偏移量，它将忽略两次大于1000秒的调整，并退出另一个调整。
    maxchange 1000 1 2
    # 该rtcfile指令定义中的文件名chronyd可以保存跟踪系统的实时时钟（RTC）的精度相关的参数。
    rtcfile /var/lib/chrony/rtc

### 3：配置服务端：

    选中一台服务器，编辑/etc/chrony.conf文件：
    vim /etc/chrony.conf

    #修改配置文件，注释其他server开头的配置
    server 172.16.20.22 iburst
    allow 0.0.0.0/0
    local stratum 10

    # 重启chronyd
    systemctl restart   chronyd

    # 查看时间同步源，查看时间同步进度
    chronyc sources –v

### 4：配置客户端

    剩余的服务器，编辑/etc/chrony.conf文件：
    vim /etc/chrony.conf

    #修改配置文件，注释其他server开头的配置
    server 172.16.20.22 iburst

    # 重启chronyd
    systemctl restart   chronyd

    # 查看时间同步源，查看时间同步进度
    chronyc sources –v
