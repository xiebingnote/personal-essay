# lockfree

高性能无锁队列

Import导入：go get github.com/bruceshao/lockfree

github地址：https://github.com/bruceshao/lockfree

在写入和读取上的性能大概都在channel的7倍以上，数据写入的越多，性能提升越明显。 下面是buffer=1024*1024时，写入数据的耗时对比：

![img_1.png](image/img_1.png)

