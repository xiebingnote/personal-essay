#!/usr/bin/env bash
nsq_path=/usr/local/nsq

is_active_nsqlookupd=`systemctl is-active nsqlookupd`
is_active_nsqd=`systemctl is-active nsqd`
is_active_nsqadmin=`systemctl is-active nsqadmin`

if [ "$is_active_nsqlookupd" == "active" ]
then
  echo -e "----------停止nsqlookupd服务----------"
  sleep 1
  systemctl stop nsqlookupd
  echo
else
  echo -e "nsqlookupd 服务未启动"
  sleep 1
  echo
fi

if [ "$is_active_nsqd" == "active" ]
then
  echo -e "----------停止nsqd服务----------"
  sleep 1
  systemctl stop nsqd
  echo
else
  echo -e "nsqd 服务未启动"
  sleep 1
  echo
fi

if [ "$is_active_nsqadmin" == "active" ]
then
  echo -e "----------停止nsqadmin服务----------"
  sleep 1
  systemctl stop nsqadmin
  echo
else
  echo -e "nsqadmin 服务未启动"
  sleep 1
  echo
fi

if [ -f /etc/systemd/system/nsqlookupd.service ]
then
  echo -e "删除nsqlookupd.service文件"
  sleep 1
  rm -f /etc/systemd/system/nsqlookupd.service
  echo
else
  echo -e "文件：nsqlookupd.service 不存在"
  sleep 1
  echo
fi

if [ -f /etc/systemd/system/nsqd.service ]
then
  echo -e "删除nsqd.sevice文件"
  sleep 1
  rm -f /etc/systemd/system/nsqd.service
  echo
else
  echo "文件：nsqd.service 不存在"
  sleep 1
  echo
fi

if [ -f /etc/systemd/system/nsqadmin.service ]
then
  echo -e "删除nsqadmin.service文件"
  sleep 1
  rm -f /etc/systemd/system/nsqadmin.service
  echo
else
  echo -e "文件：nsqadmin.service 不存在"
  sleep 1
  echo
fi

if [ -d $nsq_path ]
then
  echo -e "删除nsq文件夹"
  sleep 1
  rm -rf $nsq_path
  echo
else
  echo -e "文件夹：nsq 不存在,路径为：$nsq_path"
  sleep 1
  echo
fi

echo -e "---------------卸载完成，重新加载系统服务---------------"
sleep 1
systemctl daemon-reload
echo

