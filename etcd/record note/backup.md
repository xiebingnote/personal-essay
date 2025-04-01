# etcd快照备份

## 全量备份

    注：etcd集群备份，每个节点都要单独备份
    命令：
    etcdctl --endpoints http://172.16.20.188:2379 snapshot save test.db

    查看备份快照命令：
    etcdctl --write-out=table snapshot status test.db

## http备份脚本：

    #!bin/bash
    ip="172.16.20.23"
    port="2379"
    datadir="/var/lib/backup/etcd"
    backupname="backup.db"
    
    etcdctl --endpoints http://$ip:$port snapshot save $datadir/$backupname

## https备份脚本

    #!bin/bash
    ip="172.16.20.23"
    port="2379"
    datadir="/var/lib/backup/etcd"
    backupname="backup.db"
    cacert="/usr/local/cert/etcd-ca.crt"
    cert="/usr/local/cert/etcd-server.crt"
    key="/usr/local/cert/etcd-server.key"
    
    etcdctl --endpoints https://$ip:$port --cacert $cacert --cert $cert --key $key  snapshot save $datadir/$backupname
