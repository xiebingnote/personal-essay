# 更换yum源

## 1、备份

    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak

## 2、上传或者创建文件

### 清华源：

    # CentOS-Base.repo
    #
    # The mirror system uses the connecting IP address of the client and the
    # update status of each mirror to pick mirrors that are updated to and
    # geographically close to the client.  You should use this for CentOS updates
    # unless you are manually picking other mirrors.
    #
    # If the mirrorlist= does not work for you, as a fall back you can try the
    # remarked out baseurl= line instead.
    #
    #
    
    
    [base]
    name=CentOS-$releasever - Base
    baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/os/$basearch/
    #mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
    
    
    #released updates
    [updates]
    name=CentOS-$releasever - Updates
    baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/updates/$basearch/
    #mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
    
    
    #additional packages that may be useful
    [extras]
    name=CentOS-$releasever - Extras
    baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/extras/$basearch/
    #mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
    
    
    #additional packages that extend functionality of existing packages
    [centosplus]
    name=CentOS-$releasever - Plus
    baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/$releasever/centosplus/$basearch/
    #mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus
    gpgcheck=1
    enabled=0
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

### 阿里云源：

    # CentOS-Base.repo
    #
    # The mirror system uses the connecting IP address of the client and the
    # update status of each mirror to pick mirrors that are updated to and
    # geographically close to the client.  You should use this for CentOS updates
    # unless you are manually picking other mirrors.
    #
    # If the mirrorlist= does not work for you, as a fall back you can try the
    # remarked out baseurl= line instead.
    #
    #
    
    [base]
    name=CentOS-$releasever - Base - mirrors.aliyun.com
    failovermethod=priority
    baseurl=http://mirrors.aliyun.com/centos/$releasever/os/$basearch/
    http://mirrors.aliyuncs.com/centos/$releasever/os/$basearch/
    http://mirrors.cloud.aliyuncs.com/centos/$releasever/os/$basearch/
    gpgcheck=1
    gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
    
    #released updates
    [updates]
    name=CentOS-$releasever - Updates - mirrors.aliyun.com
    failovermethod=priority
    baseurl=http://mirrors.aliyun.com/centos/$releasever/updates/$basearch/
    http://mirrors.aliyuncs.com/centos/$releasever/updates/$basearch/
    http://mirrors.cloud.aliyuncs.com/centos/$releasever/updates/$basearch/
    gpgcheck=1
    gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
    
    #additional packages that may be useful
    [extras]
    name=CentOS-$releasever - Extras - mirrors.aliyun.com
    failovermethod=priority
    baseurl=http://mirrors.aliyun.com/centos/$releasever/extras/$basearch/
    http://mirrors.aliyuncs.com/centos/$releasever/extras/$basearch/
    http://mirrors.cloud.aliyuncs.com/centos/$releasever/extras/$basearch/
    gpgcheck=1
    gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
    
    #additional packages that extend functionality of existing packages
    [centosplus]
    name=CentOS-$releasever - Plus - mirrors.aliyun.com
    failovermethod=priority
    baseurl=http://mirrors.aliyun.com/centos/$releasever/centosplus/$basearch/
    http://mirrors.aliyuncs.com/centos/$releasever/centosplus/$basearch/
    http://mirrors.cloud.aliyuncs.com/centos/$releasever/centosplus/$basearch/
    gpgcheck=1
    enabled=0
    gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
    
    #contrib - packages by Centos Users
    [contrib]
    name=CentOS-$releasever - Contrib - mirrors.aliyun.com
    failovermethod=priority
    baseurl=http://mirrors.aliyun.com/centos/$releasever/contrib/$basearch/
    http://mirrors.aliyuncs.com/centos/$releasever/contrib/$basearch/
    http://mirrors.cloud.aliyuncs.com/centos/$releasever/contrib/$basearch/
    gpgcheck=1
    enabled=0
    gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

## 3、生成缓存

    yum makecache


