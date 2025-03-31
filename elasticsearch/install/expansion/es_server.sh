#!/usr/bin/bash

echo -e "---------------加载elasticsearch服务---------------"
sleep 1
systemctl daemon-reload
echo

echo -e "---------------启动elasticsearch服务并设置开机自启动---------------"
sleep 1
systemctl start elasticsearch
systemctl enable elasticsearch
systemctl status elasticsearch
echo
es_active=`systemctl is-active elasticsearch`

if [ $es_active == "active" ]
then
sleep 1
echo -e "----------------安装完成！请按照安装文档的验证步骤进行检验！---------------"
else
  echo -e "----------------elasticsearch服务安装异常，请排查原因后重新部署！---------------"
  echo
fi

