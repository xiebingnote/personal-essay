#!/usr/bin/env bash
etcd_path=/opt/etcd
is_active_etcd=`systemctl is-active etcd`
etcd_data="/var/lib/etcd"


if [ "$is_active_etcd" == "active" ]
then
  echo -e "----------停止etcd服务----------"
  sleep 1
  systemctl stop etcd
  echo
else
  echo -e "etcd 服务未启动"
  sleep 1
  echo
fi

if [ -f /etc/systemd/system/etcd.service ]
then
  echo -e "删除etcd.sevice文件"
  sleep 1
  rm -f /etc/systemd/system/etcd.service
  echo
else
  echo "文件：etcd.service 不存在"
  sleep 1
  echo
fi

if [ -d $etcd_path ]
then
  echo -e "删除etcd文件夹"
  sleep 1
  rm -rf $etcd_path
  echo
else
  echo -e "文件夹：etcd 不存在,路径为：$etcd_path"
  sleep 1
  echo
fi

if [ -d $etcd_data ]
then
  echo -e "删除etcd数据文件夹"
  sleep 1
  rm -rf $etcd_data
  echo
else
  echo -e "数据文件夹：etcd 不存在,路径为：$etcd_data"
  sleep 1
  echo
fi

echo -e "---------------卸载完成，重新加载系统服务---------------"
sleep 1
systemctl daemon-reload
echo

