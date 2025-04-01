# 标密证书

## 1、go代码报错： x509: cannot validate certificate for x.x.x.x because it doesn't contain any IP SANs

    解决方法如下：
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = nonRepudiation, digitalSignature, keyEncipherment
    
    subjectAltName = @alt_names
    
    [ alt_names ]
    IP.1 = 127.0.0.1
    
    [ v3_ca ]
    subjectAltName = @alt_names

## 2、制作加密证书，更改openssl.cnf，添加：

    [ v3enc_req ]
    basicConstraints = CA:FALSE
    keyUsage = keyAgreement, keyEncipherment, dataEncipherment
    subjectAltName = @alt_names
    
    [ alt_names ]
    IP.1 = 127.0.0.1
    
    [ v3_ca ]
    subjectAltName = @alt_names

## 3、制作证书脚本：opensslcert.sh

    #!/usr/bin/env bash
    
    #生成CA证书
    #创建私钥
    openssl genrsa -out ca-key.pem 2048
    
    #创建证书请求
    openssl req -new -key ca-key.pem -out ca-req.csr -subj /C=CN/ST=JS/L=NJ/O=NJ/CN="127.0.0.1"
    
    #自签证书
    openssl x509 -req -in ca-req.csr -out ca.cert -extensions v3_ca -signkey ca-key.pem -days 3650
    
    
    
    #生成Server自签证书
    #创建私钥
    openssl genrsa -out server-key.pem 2048
    
    #创建证书请求
    openssl req -new -key server-key.pem -out server-req.csr -subj /C=CN/ST=JS/L=NJ/O=NJ/CN="127.0.0.1"
    
    #自签证书
    openssl x509 -req -in server-req.csr -extfile /etc/pki/tls/openssl.cnf -extensions v3_req -CA ca.cert -CAkey ca-key.pem -CAcreateserial -extfile /etc/pki/tls/openssl.cnf -out server.cert -days 3650
    
    #验签
    openssl verify -CAfile ca.cert server.cert
    
    
    
    #生成Server加密证书
    #创建私钥
    openssl genrsa -out serverenc-key.pem 2048
    
    #创建加密证书请求
    openssl req -new -key serverenc-key.pem -out serverenc-req.csr -subj /C=CN/ST=JS/L=NJ/O=NJ/CN="127.0.0.1"
    
    #自签加密证书
    openssl x509 -req -in serverenc-req.csr -extfile /etc/pki/tls/openssl.cnf -extensions v3enc_req -CA ca.cert -CAkey ca-key.pem -CAcreateserial -extfile /etc/pki/tls/openssl.cnf -out serverenc.cert -days 3650
    
    #验签
    openssl verify -CAfile ca.cert serverenc.cert
    
    
    
    #生成Client自签证书
    #创建私钥
    openssl genrsa -out client-key.pem 2048
    
    #创建证书请求
    openssl req -new -key client-key.pem -out client-req.csr -subj /C=CN/ST=JS/L=NJ/O=NJ/CN="127.0.0.1"
    
    #自签证书
    openssl x509 -req -in client-req.csr -extfile /etc/pki/tls/openssl.cnf -extensions v3_req -CA ca.cert -CAkey ca-key.pem -CAcreateserial -extfile /etc/pki/tls/openssl.cnf -out client.cert -days 3650
    
    #验签
    openssl verify -CAfile ca.cert client.cert

## 4、查看证书内容命令：

    openssl x509 -noout -in ca.cert -text

## 5、验签：

    openssl verify -CAfile ca.cert serverenc.cert
