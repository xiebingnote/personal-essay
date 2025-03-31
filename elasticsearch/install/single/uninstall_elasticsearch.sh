#!/usr/bin/env bash
es_path="/usr/local/elasticsearch"
es_user="es"
is_active_elasticsearch=`systemctl is-active elasticsearch`

if [ "$is_active_elasticsearch" == "active" ]
then
  echo -e "----------停止elasticsearch服务----------"
  sleep 1
  systemctl stop elasticsearch
  echo
else
  echo -e "elasticsearch 服务未启动"
  sleep 1
  echo
fi

if [ -f /etc/systemd/system/elasticsearch.service ]
then
  echo -e "删除elasticsearch.service文件"
  sleep 1
  rm -f /etc/systemd/system/elasticsearch.service
  echo
else
  echo -e "文件：elasticsearch.service 不存在"
  sleep 1
  echo
fi

if [ -f /etc/security/limits.conf ]
then
  echo -e "还原/etc/security/limits.conf 文件"
  sleep 1
  /bin/cp /etc/security/limits.conf.bak /etc/security/limits.conf
  echo
else
  echo -e "文件：/etc/security/limits.conf 未备份，无法还原"
  sleep 1
  echo
fi

if [ -f /etc/security/limits.d/20-nproc.conf.bak ]
then
  echo -e "还原/etc/security/limits.d/20-nproc.conf 文件"
  sleep 1
  /bin/cp /etc/security/limits.d/20-nproc.conf.bak /etc/security/limits.d/20-nproc.conf
  echo
else
  echo -e "文件：/etc/security/limits.d/20-nproc.conf 未备份，无法还原"
  sleep 1
  echo
fi

if [ -f /etc/sysctl.conf.bak ]
then
  echo -e "还原/etc/sysctl.conf 文件"
  sleep 1
  /bin/cp /etc/sysctl.conf.bak /etc/sysctl.conf
  echo
  
  echo -e "---------------重新加载sysctl服务---------------"
  echo -e "服务加载后输出内容："
  sleep 1
  sysctl -p
  echo

else
  echo -e "文件：/etc/sysctl.conf 未备份，无法还原"
  sleep 1
  echo
fi

if id -u ${es_user} >/dev/null 2>&1 ; then
  echo "刪除用户：$es_user"
  sleep 1
  userdel -r $es_user
  echo
else
  echo -e "$es_user is not exisit!"
  sleep 1
  echo
fi

if [ -d $es_path ]
then
  echo -e "删除elasticsearch文件夹"
  sleep 1
  rm -rf $es_path
  echo
else
  echo -e "文件夹：elasticsearch 不存在,路径为：$es_path"
  sleep 1
  echo
fi

echo -e "---------------卸载完成，重新加载系统服务---------------"
sleep 1
systemctl daemon-reload
echo
