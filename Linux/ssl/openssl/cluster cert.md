# 集群证书生成

## 步骤:

### 1、更改配置文件中的ip和dns名称地址：

    [ req ]
    default_bits = 2048
    prompt = no
    default_md = sha256
    req_extensions = req_ext
    distinguished_name = dn
    
    
    [ dn ]
    C = CN
    ST = BeiJing
    L = BeiJing
    O = nsq
    CN = nsq
    
    
    [ req_ext ]
    subjectAltName = @alt_names
    
    
    [ alt_names ]
    DNS.1 = localhost
    DNS.2 = node1
    DNS.3 = node2
    DNS.4 = node3
    IP.1 = 127.0.0.1
    IP.2 = 172.16.20.187
    IP.3 = 172.16.20.188
    IP.4 = 172.16.20.189
    
    
    [ v3_ext ]
    authorityKeyIdentifier=keyid,issuer:always
    basicConstraints=CA:FALSE
    keyUsage=keyEncipherment,dataEncipherment
    extendedKeyUsage=serverAuth,clientAuth
    subjectAltName=@alt_names

### 2、更改执行脚本中的O和CN的值，更改extfile的执行文件名称：

    #!bin/bash
    #生成根证书
    openssl genrsa -out ca.key 2048
    openssl req -x509 -new -nodes -key ca.key -days 10000 -out ca.crt -subj /C=CN/ST=BeiJing/L=BeiJing/O=nsq/CN=nsq
    
    
    #签发服务器证书
    openssl genrsa -out server.key 2048
    openssl req -new -key server.key -out server.csr -config nsq-ca.conf
    openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 10000 -extensions v3_ext -extfile nsq-ca.conf
    
    
    #签发客户端证书
    openssl genrsa -out client.key 2048
    openssl req -new -key client.key -out client.csr -config nsq-ca.conf
    openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 10000 -extensions v3_ext -extfile nsq-ca.conf
    
    
    #验证
    openssl verify -CAfile ca.crt server.crt
    openssl verify -CAfile ca.crt client.crt
    rm -f *.csr *.srl
