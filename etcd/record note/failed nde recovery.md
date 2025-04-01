# etcd故障节点恢复

## 1、Panic:failed to get all reachable pages

### 解决方法：

    1：列出所有故障节点
    etcdctl member list -w=table
    
    2：查看所有节点健康状态
    etcdctl --endpoints http://172.16.20.22:2379,http://172.16.20.30:2379,http://172.16.20.46:2379 endpoint health  -w=table
    
    3：删除故障节点
    etcdctl member remove fcbcc452c50c9e76
    
    4：修复故障节点（故障节点上操作）
    vim /etc/systemd/system/etcd.service
    
    #把--initial-cluster-state的new改为existing
    
    --initial-cluster-state existing
    
    5：清理故障节点数据
    #根据实际情况删除
    rm -rf /var/lib/etcd/data/
    
    6：重新添加故障节点（正常节点上操作）
    etcdctl member add etcd01 --peer-urls=http://172.16.20.22:2380
    
    7：重启故障节点（故障节点上操作）
    systemctl restart etcd

## 2、日志输出参数：--log-outputs

    --log-outputs=/var/lib/etcd/log/etcd.log

