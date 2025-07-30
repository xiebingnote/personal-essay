# flink 2.0以上版本：

## flink sql

    执行报错： [ERROR] Could not execute SQL statement. Reason: java.lang.ClassNotFoundException: org.apache.flink.streaming.api.functions.source.SourceFunction
    原因：版本不兼容
    jar包：flink-connector-starrocks-1.2.11_flink-1.20.jar  flink-sql-connector-mysql-cdc-3.4.0.jar mysql-connector-java-8.0.27.jar
    其中flink connector starrocks 降级后也是一样的报错，降级版本为:flink-connector-starrocks-1.2.11_flink-1.19.jar  flink-connector-starrocks-1.2.10_flink-1.19.ja

## flink cdc

    jar包：flink-connector-starrocks-1.2.11_flink-1.20.jar  flink-sql-connector-mysql-cdc-3.4.0.jar mysql-connector-java-8.0.27.jar
    flink-cdc-pipeline-connector-starrocks-3.4.0.jar  flink-cdc-pipeline-connector-mysql-3.4.0.jar flink-cdc-runtime-3.4.0.jar

    报错：Exception in thread "main" java.lang.NoSuchFieldError: DROP_TABLE
    原因：缺少runtime依赖，添加flink-cdc-runtime-3.4.0.jar 后报错：
    
    Exception in thread "main" java.lang.NoSuchFieldError: chainingStrategy 
    原因：版本不兼容：
    