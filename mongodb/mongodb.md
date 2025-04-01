# MongoDB

## MongoDB Overview

### 1、docker版本mongo进入：

    docker exec -it mongo bash
    mongo mongodb://数据库用户名:密码@127.0.0.1:27017

    或者：
    docker exec -it mongo mongo mongodb://数据库用户名:密码@127.0.0.1:27017
    docker exec -it 容器ID mongo mongodb://数据库用户名:密码@127.0.0.1:27017

### 2、docker中mongo数据导出：

    docker exec -it 09b4cd323c66 mongodump -u xxx -p xxx --host 127.0.0.1:27017 --db=test --collection=objects --authenticationMechanism=SCRAM-SHA-1 --out=/data/db/dump
    导出后数据在docker容器中，找到对应的映射路径：dcoker inspect mongo

    导出某个表，指定数据库和表：--db=test  --collection=objects
    导出某个数据库：--db=test
    导出全部，不写--db和--collection

### 3、二进制版本导出mongo数据库

    mongodump -u xxx -p xxx -h 127.0.0.1:37017  --ssl --sslCAFile=conf/common/CAs/mongo_ca_root.crt -o mongodb

### 4、二进制版本mongo导入数据：

    需要安装：mongod-org-tools的rpm包：
    mongorestore mongodb://数据库用户名:密码@127.0.0.1:37017/?replicaSet=rs_gdas --ssl --sslCAFile  /home/xxx/conf/common/CAs/mongo_ca_root.crt copy/

### 5、mongodb模糊查询并统计：

    db.getCollection('objects').aggregate([{$match: {"bucket":"test001","name":{$regex:"align"},"ismultipart":true}}, {$group: {_id: null, sumSize: {$sum: "$size"}}}])
    db.getCollection('objects').aggregate([{$match: {"bucket":"test001","name":{$regex:"align"},"ismultipart":true}}, {$group: {_id: "$name", sumSize: {$sum: "$size"}}}])

### 6、连接到指定的数据库并查询：

    mongo  mongodb://数据库用户名:密码@127.0.0.1:37017/?replicaSet=rs_gdas --tls --tlsCAFile  /home/xxx/conf/common/CAs/mongo_ca_root.crt --eval 'db=db.getSiblingDB("cluster_default");db.getCollection("bps").find({"id":"xxx"});'


 