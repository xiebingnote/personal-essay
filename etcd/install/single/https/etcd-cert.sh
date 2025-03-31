#!bin/bash
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -days 10000 -out ca.crt -subj /C=CN/ST=BeiJing/L=BeiJing/O=etcd/CN=etcd

openssl genrsa -out etcd.key 2048
openssl req -new -key etcd.key -out etcd.csr -config etcd-ca.conf
openssl x509 -req -in etcd.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out etcd.crt -days 10000 -extensions v3_ext -extfile etcd-ca.conf
openssl verify -CAfile ca.crt etcd.crt
