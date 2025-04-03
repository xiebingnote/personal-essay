# github.com/xiebingnote/personal-essay

项目介绍：个人学习笔记、实践经验、踩坑记录，包含Linux、Docker、Git、Kafka、NSQ、MongoDB、MySQL、Nginx、PostgreSQL、Wireshark等相关知识。

项目地址：https://github.com/xiebingnote/personal-essay

仅供参考学习，线上请谨慎使用！！！

## 1. 相关说明

1. Linux: 包含开机重置密码、yum源替换、iptables、logrotate 日志轮转、服务创建、管理、shell脚本相关操作命令、ssl
   标密证书制作、GMSSL国密证书制作配置、vim相关等。
2. Docker: 相关问题记录。
3. Elasticsearch: 包含 Elasticsearch 安装、集群部署、扩容、单节点部署、备份、操作、问题记录等。
4. Etcd: 包含 Etcd 安装、集群部署、扩容、单节点部署、备份、操作、问题记录等。
5. Git: 包含 Git 常用命令、Git 仓库管理、Git 分支管理、Git 合并、Git 回滚等。
6. Golang：包含 Golang 常用库、工具、问题记录等。
7. Kafka: 包含 Kafka 安装、集群部署、单节点部署。
8. Kibana: 包含 Kibana 安装、配置、使用等。
9. MongoDB: MongoDB 使用记录。
10. MySQL: 包含 MySQL 使用、数据库备份、操作、问题记录等。
11. Nginx: 包含 Linux + Nginx 安装配置https 使用记录。
12. Nsq: 包含 Nsq 安装、集群部署、扩容、单节点部署、备份、操作、问题记录等。
13. PostgreSQL: 包含 PostgreSQL 使用记录。
14. Wireshark: Wireshark 相关记录。

## 2. 项目结构

    .
    ├── Linux           # Linux 目录
    │ ├── centos-7      # 开机重置密码和yum源替换
    │ ├── chrony        # 配置chrony时间同步
    │ ├── command       # 常用命令
    │ ├── iptables      # iptables 相关
    │ ├── lograte       # lograte 日志管理
    │ ├── service       # 服务创建、管理
    │ ├── shell         # shell 脚本相关操作命令
    │ ├── ssl           # ssl 目录
    │ │ ├── gmssl       # 国密证书制作
    │ │ └── openssl     # 标密证书制作
    │ └── vim           # vim 相关
    ├── README.md       # README 说明
    ├── docker          # docker 相关记录
    ├── elasticsearch   # elasticsearch 
    │ ├── install       # elasticsearch 安装目录
    │ │ ├── cluster     # elasticsearch 集群部署
    │ │ ├── expansion   # elasticsearch 扩容
    │ │ └── single      # elasticsearch 单节点部署
    │ └── record note   # elasticsearch 备份、操作、问题记录
    ├── etcd            # etcd 
    │ ├── install       # etcd 安装
    │ │ ├── cluster     # etcd 集群部署
    │ │ ├── expansion   # etcd 扩容
    │ │ └── single      # etcd 单节点部署
    │ └── record note   # etcd 备份、操作、问题记录
    ├── git             # git 目录
    ├── golang          # golang 相关库
    │ └── tools         # go 第三方工具库
    ├── kafka           # kafka 
    │ └── install       # kafka 安装目录
    ├── kibana          # kibana 目录
    ├── mongodb         # mongodb 文件夹
    ├── mysql           # mysql 文件夹
    ├── nginx           # nginx 搭建 https
    ├── nsq             # nsq 
    │ └── install       # nsq 安装
    │     ├── cluster   # nsq 集群部署
    │     ├── expansion # nsq 扩容
    │     └── single    # nsq 单节点部署
    ├── postgresql      # postgresql 目录
    └── wireshark       # wireshark 目录