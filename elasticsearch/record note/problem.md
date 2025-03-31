# Problem

## 1、在使用Elasticsearch的RestHightClient API 去搜索ES数据，当请求的参数过长的出现下面的异常：

    {"type":"too_long_frame_exception","reason":"An HTTP line is larger than 4096 bytes."}

    原因：默认情况下ES对请求参数设置为4K，如果遇到请求参数长度限制可以在elasticsearch.yml中添加或修改如下参数：

    http.max_initial_line_length: "1M"
    
    http.max_header_size: "1M"

## 2、未引导的分片处理

### 1：查看分片

    curl -uelastic:123456 --cert /usr/local/elasticsearch/config/cert/my-es.crt --key /usr/local/elasticsearch/config/cert/my-es.key  --cacert /usr/local/elasticsearch/config/cert/ca.crt https://172.16.20.23:9200/_cat/shards?pretty | grep UNASSIGNE
    主分片：p
    副本分片：r

### 2：查看分片未引导原因

    curl -X GET -uelastic:123456 --cert /usr/local/elasticsearch/config/cert/my-es.crt --key /usr/local/elasticsearch/config/cert/my-es.key  --cacert /usr/local/elasticsearch/config/cert/ca.crt https://172.16.20.23:9200/_cluster/allocation/explain?pretty

### 3：查看es空间使用率

    curl -X GET -uelastic:123456 --cert /usr/local/elasticsearch/config/cert/my-es.crt --key /usr/local/elasticsearch/config/cert/my-es.key  --cacert /usr/local/elasticsearch/config/cert/ca.crt https://172.16.20.23:9200/_cat/allocation?v=true&h=node,shards,disk.*

## 3、状况原因及解决方法：

### 1：分片太多，节点不够

    原因：
    确保分片的多个副本不会分配给同一个节点，如果主分片和副本分片在一个集群分配在同一节点，如果此节点挂了，整个index数据都会丢失，副本就无存在的意义了
    
    解决方法：
    （1）设置所有副本分片数为节点数-1或者少于节点数，单机设置分片数为0
    curl -X PUT -uelastic:123456 --cert /usr/local/elasticsearch/config/cert/my-es.crt --key /usr/local/elasticsearch/config/cert/my-es.key  --cacert /usr/local/elasticsearch/config/cert/ca.crt https://172.16.20.23:9200/_settings -H 'Content-Type: application/json' -d' {"number_of_replicas":0}'
    
    （2）关闭自动分片
    curl -X PUT -uelastic:123456 --cert /usr/local/elasticsearch/config/cert/my-es.crt --key /usr/local/elasticsearch/config/cert/my-es.key  --cacert /usr/local/elasticsearch/config/cert/ca.crt https://172.16.20.23:9200/_cluster/_settings -H 'Content-Type: application/json' -d' {"transient" : {"cluster.routing.allocation.enable":"none"}}'

### 2：shard默认延迟分配

    原因：
    在某个节点与master失去联系后，集群不会立刻重新allocation，而是会延迟一段时间确定此节点是否会重新加入集群。如果重新加入，则此节点会保持现有的分片数据，不会触发新的分片分配
    
    解决方法：
    修改所有索引的delayed_timeout默认等待时间，下面为设置10分钟，不想等待，可以设置为0
    curl -X PUT -uelastic:123456 --cert /usr/local/elasticsearch/config/cert/my-es.crt --key /usr/local/elasticsearch/config/cert/my-es.key  --cacert /usr/local/elasticsearch/config/cert/ca.crt https://172.16.20.23:9200/_all/_settings -H 'Content-Type: application/json' -d' {"index.unassigned.node_left.delayed_timeout":"10m"}'

### 3：磁盘使用率超过阈值

    1：超过85%：ES不会将分片分配给磁盘使用率超过85%的节点
    2：超过90%：ES会将对应节点的分片迁移到其他磁盘使用率比较小的节点中
    3：超过95%：ES会强制每个索引只允许读或者删除，恢复写入命令如下：
    curl -X PUT -uelastic:123456 --cert /usr/local/elasticsearch/config/cert/my-es.crt --key /usr/local/elasticsearch/config/cert/my-es.key  --cacert /usr/local/elasticsearch/config/cert/ca.crt https://172.16.20.23:9200/_all/_settings -H 'Content-Type: application/json' -d' {"persistent":{"cluster.blocks.read_only":false}}'

### 4：未开启分片分配功能

    方法：开启分片分配
    curl -X PUT -uelastic:123456 --cert /usr/local/elasticsearch/config/cert/my-es.crt --key /usr/local/elasticsearch/config/cert/my-es.key  --cacert /usr/local/elasticsearch/config/cert/ca.crt https://172.16.20.23:9200/_cluster/settings -H 'Content-Type: application/json' -d' {"transient":{"cluster.routing.allocation.enable":"all"}}'
    
    禁用分片：
    curl -X PUT -uelastic:123456 --cert /usr/local/elasticsearch/config/cert/my-es.crt --key /usr/local/elasticsearch/config/cert/my-es.key  --cacert /usr/local/elasticsearch/config/cert/ca.crt https://172.16.20.23:9200/_cluster/settings -H 'Content-Type: application/json' -d' {"transient":{"cluster.routing.allocation.enable":"none"}}'

## 4、ElasticSearch 集群的高可用和自平衡方案会在节点挂掉（重启）后自动在别的结点上复制该结点的分片，导致了大量的IO和网络开销。

### 原因：

    离开的节点重新加入集群，elasticsearch为了对数据分片(shard)进行再平衡，会为重新加入的节点再次分配数据分片(Shard)；当一台es因为压力过大而挂掉以后，其他的es服务会备份本应那台es保存的数据，造成更大压力，会导致整个集群会发生雪崩。
    生产环境的 ElasticSearch 服务如果负载过重，单台服务器不稳定；则集群稳定性就会因为自动平衡机制，再遭重创。生产环境下建议关闭自动平衡

### 解决方法：

#### 1：关闭自动分片（新建index也无法分配数据分片）

    curl -X PUT -uelastic:123456 --cert /usr/local/elasticsearch/config/cert/my-es.crt --key /usr/local/elasticsearch/config/cert/my-es.key  --cacert /usr/local/elasticsearch/config/cert/ca.crt https://172.16.20.23:9200/_cluster/settings -H 'Content-Type: application/json' -d' {"transient":{"cluster.routing.allocation.enable":"none"}}'

#### 2：关闭自动平衡（只在增减ES节点时不自动平衡数据分片）

    curl -X PUT -uelastic:123456 --cert /usr/local/elasticsearch/config/cert/my-es.crt --key /usr/local/elasticsearch/config/cert/my-es.key  --cacert /usr/local/elasticsearch/config/cert/ca.crt https://172.16.20.23:9200/_cluster/settings -H 'Content-Type: application/json' -d' {"transient":{"cluster.routing.rebalance.enable":"none"}}'

#### 3：打开自动分片，自动平衡

    curl -X PUT -uelastic:123456 --cert /usr/local/elasticsearch/config/cert/my-es.crt --key /usr/local/elasticsearch/config/cert/my-es.key  --cacert /usr/local/elasticsearch/config/cert/ca.crt https://172.16.20.23:9200/_cluster/settings -H 'Content-Type: application/json' -d' {"transient":{"cluster.routing.allocation.enable":"all","cluster.routing.rebalance.enable":"all"}}'
    
    persistent：重启后设置也会存在
    transient：整个集群重启后会消失的设置