#!/usr/bin/env bash
kafka_path="/opt/kafka"

is_active_zookeeper=`systemctl is-active zookeeper`
is_active_kafka=`systemctl is-active kafka`

if [ "$is_active_kafka" == "active" ]
then
  echo -e "----------停止kafka服务----------"
  sleep 1
  systemctl stop kafka
  echo
else
  echo -e "kafka 服务未启动"
  sleep 1
  echo
fi

if [ "$is_active_zookeeper" == "active" ]
then
  echo -e "----------停止zookeeper服务----------"
  sleep 1
  systemctl stop zookeeper
  echo
else
  echo -e "zookeeper 服务未启动"
  sleep 1
  echo
fi

if [ -f /etc/systemd/system/zookeeper.service ]
then
  echo -e "删除zookeeper.sevice文件"
  sleep 1
  rm -f /etc/systemd/system/zookeeper.service
  echo
else
  echo "文件：zookeeper.service 不存在"
  sleep 1
  echo
fi

if [ -f /etc/systemd/system/kafka.service ]
then
  echo -e "删除kafka.sevice文件"
  sleep 1
  rm -f /etc/systemd/system/kafka.service
  echo
else
  echo "文件：kafka.service 不存在"
  sleep 1
  echo
fi

if [ -d $kafka_path ]
then
  echo -e "删除nsq文件夹"
  sleep 1
  rm -rf $kafka_path
  echo
else
  echo -e "文件夹：kafka 不存在,路径为：$kafka_path"
  sleep 1
  echo
fi

echo -e "---------------卸载完成，重新加载系统服务---------------"
sleep 1
systemctl daemon-reload
echo

