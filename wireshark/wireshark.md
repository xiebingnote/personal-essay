# Wireshark

## 1、Wireshark抓包后保存的文件后缀：.pcapng

## 2、Linux抓包

    tcpdump -n -i eth0 port 8080

## 3、配置解析MMS协议

    选择 Edit->preferences->protocol->PRES ，然后编辑 users context tale，添加一项：context = 3 and OID = 1.0.9506.2.3