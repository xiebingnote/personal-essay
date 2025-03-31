#!/usr/bin/bash
echo -e "---------------加载nsq服务---------------"
sleep 1
systemctl daemon-reload
echo  

echo -e "---------------启动nsqlookupd服务并设置开机自启动---------------"
sleep 1
systemctl start nsqlookupd
systemctl enable nsqlookupd
systemctl status nsqlookupd
echo

echo -e "---------------启动nsqd服务并设置开机自启动---------------"
sleep 1
systemctl start nsqd
systemctl enable nsqd
systemctl status  nsqd
echo

echo -e "---------------启动nsqadmin服务并设置开机自启动---------------"
sleep 1
systemctl start nsqadmin
systemctl enable nsqadmin
systemctl status nsqadmin
echo

nsqd_active=`systemctl is-active nsqd`
nsqadmin_active=`systemctl is-active nsqadmin`
nsqlookupd_active=`systemctl is-active nsqlookupd`

if [ $nsqd_active == "active" ] && [ $nsqadmin_active == "active" ] && [ $nsqlookupd_active == "active" ]
then
sleep 1
echo -e "----------------安装完成！请按照安装文档的验证步骤进行检验！---------------"
else
  if [ ! $nsqd_active == "active" ]
  then
   echo -e "----------------nsqd服务安装异常，请排查原因后重新部署！---------------"
   echo
  fi

  if [ ! $nsqadmin_active == "active" ]
  then
   echo -e "----------------nsqadmin服务安装异常，请排查原因后重新部署！---------------"
   echo
  fi

  if [ ! $nsqlookupd_active == "active" ]
  then
   echo -e "----------------nsqlookupd服务安装异常，请排查原因后重新部署！---------------"
   echo
  fi
fi
