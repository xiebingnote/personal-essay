# Operation Commands

## 1、更改ES指定用户密码：

    ./bin/elasticsearch-reset-password --username elastic -i

## 2、ES生成证书报错：

    warning: ignoring JAVA_HOME=/usr/local/elasticsearch/jdk; using ES_JAVA_HOME
    The minimum required Java version is 17; your Java version from [/usr/local/java/jdk1.8.0_231/jre] does not meet this requirement
    原因：jdk版本不符合要求导致
    解决方法：在/etc/profile文件中配置ES_JAVA_HOME为ES自带的jdk即可



