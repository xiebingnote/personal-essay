# iptables

## 1：解决service iptables save出错please try to use systemctl.

    方法：
    1：停止防火墙
    systemctl stop firewalld

    2：安装iptables-services服务
    yum install iptables-services -y

    3：开启防火墙服务
    systemctl start iptables

## 2：iptables 开放端口：

    若/etc/sysconfig/iptables不存在：

### 原因：

    在新安装的linux系统中，防火墙默认是被禁掉的，一般也没有配置过任何防火墙的策略，所以不存在/etc/sysconfig/iptables文件。

### 解决：

    1：在控制台使用iptables命令随便写一条防火墙规则，如：iptables -P OUTPUT ACCEPT
    2：使用service iptables save进行保存，默认就保存到了/etc/sysconfig目录下的iptables文件中

### 如果想开放端口（如：8889）

    （1）通过vi /etc/sysconfig/iptables 进入编辑增添一条-A INPUT -p tcp -m tcp --dport 8889 -j ACCEPT 即可

    （2）执行 /etc/init.d/iptables restart 命令将iptables服务重启

    如若不想修改iptables表，可以直接输入下面命令：
    iptables -I INPUT -p tcp --dport 8889 -j ACCEPT
