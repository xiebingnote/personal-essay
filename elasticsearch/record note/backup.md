# 快照备份

    创建快照备份文件夹并更改所属用户组为es账户的用户组
    注：如不更改文件夹所属用户组，会导致es无写入权限报错

## 修改es的elasticsearch.yaml配置文件，添加path.repo配置后重启服务

    #快照存储路径
    path.repo: [快照存储路径]

## 在es集群的主节点（其他节点无写入权限）创建共享文件系统

    #location为配置文件中paath.repo所配置的子路径，所以也可以写相对路径
    #compress是否启用压缩，默认为true
    #sag_backup为创建的共享文件系统名称（自行更改）
    #命令如下
    curl -X PUT "http://elastic:123456@172.16.20.188:9200/_snapshot/sag_backup" -H 'Content-Type:application/json' -d '{"type":"fs","settings":{"location":"/usr/local/backup-es","compress":true}}'

## 创建第一个快照

    #命令
    curl -X PUT http://elastic:123456@172.16.20.188:9200/_snapshot/sag_backup/sag_snapshost_1?pretty