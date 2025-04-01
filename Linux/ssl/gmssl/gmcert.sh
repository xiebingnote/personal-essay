#!/usr/bin/env bash

gmssl_path="/opt/gmssl"
path=`pwd`
name_ca="ca"
server_sign="server_sign"
server_encode="server_encode"

chmod 777 $path/createkey

echo "-----------------------------生成CA证书----------------------------------"
./createkey ${name_ca}
gmssl req -new -SM3 -key ${name_ca}.key -out ${name_ca}.req -subj /C=CN/ST=JS/L=NJ/O=NJ/CN="127.0.0.1"
gmssl x509 -req -days 3650 -sm3 -in ${name_ca}.req -extfile $gmssl_path/apps/openssl.cnf -extensions v3_ca -signkey ${name_ca}.key -out ${name_ca}.cer
gmssl x509 -in ${name_ca}.cer -text -noout  
rm -f ${name_ca}.req


echo "-----------------------------Server签名证书----------------------------------"
# Server签名证书
./createkey ${server_sign}
gmssl req -new -SM3 -key $path/${server_sign}.key -out ${server_sign}.req -subj /C=CN/ST=JS/L=NJ/O=NJ/CN="127.0.0.1"
gmssl x509 -req -SM3 -days 3650 -in $path/${server_sign}.req -extfile $gmssl_path/apps/openssl.cnf -extensions v3_req -CA $path/ca.cer -CAkey $path/ca.key -set_serial 1000000001 -extfile $gmssl_path/apps/openssl.cnf -out ${server_sign}.cer
gmssl x509 -in $path/${server_sign}.cer -text -noout
rm -f $path/${server_sign}.req

echo "-----------------------------Server加密证书----------------------------------"
# Server加密证书
./createkey ${server_encode}
gmssl req -new -SM3 -key $path/${server_encode}.key -out ${server_encode}.req -subj /C=CN/ST=JS/L=NJ/O=NJ/CN="127.0.0.1"
gmssl x509 -req -SM3 -days 3650 -in $path/${server_encode}.req -extfile $gmssl_path/apps/openssl.cnf -extensions v3enc_req -CA $path/ca.cer -CAkey $path/ca.key -set_serial 1000000001 -extfile $gmssl_path/apps/openssl.cnf -out ${server_encode}.cer
gmssl x509 -in $path/${server_encode}.cer -text -noout
rm -f $path/${server_encode}.req

rm -f $path/createkey.key
