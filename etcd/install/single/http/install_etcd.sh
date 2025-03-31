#!/usr/bin/env bash
etcd_path="/opt"
etcd_tar_name="etcd.tar.gz"
datadir="/var/lib/etcd"

read -p "请输入当前服务器地址：" node_ip
echo
echo -e "您输入的IP地址为：$node_ip"
echo
read -p "请核对您输入的IP,确认是否继续执行(Y/N)：" execute
echo

if [ "$execute" == "Y" ]
  then
  if [ ! -d "$datadir" ] ; then
    mkdir -p $datadir
  fi

  echo -e "-----------------解压etcd压缩包-----------------"
  sleep 1
  /bin/tar -zvxf $etcd_tar_name -C $etcd_path
  echo

  echo -e "---------------创建etcd软连接命令---------------"
  sleep 1
  if [ ! -f "/bin/etcd" ] ; then
    /bin/ln -s ${etcd_path}/etcd/Packages/etcd /bin/etcd
  else
    echo -e  "-------------etcd 命令软连接已建立-------------"
    echo
    sleep 1
  fi

  if [ ! -f "/bin/etcdctl" ] ; then
    /bin/ln -s ${etcd_path}/etcd/Packages/etcdctl /bin/etcdctl
  else
    echo -e  "------------etcdctl 命令软连接已建立-----------"
    echo
    sleep 1
  fi

  if [ ! -f "/bin/etcdutl" ] ; then
    /bin/ln -s ${etcd_path}/etcd/Packages/etcdutl /bin/etcdutl
  else
    echo -e  "------------etcdutl 命令软连接已建立-----------"
    echo
    sleep 1
  fi

  echo -e "------------------配置etcd服务------------------"
  sleep 1
  echo
cat > /etc/systemd/system/etcd.service << EOF
[Unit]
Description=etcd server
After=network.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/bin/etcd \\
--listen-client-urls http://$node_ip:2379 \\
--advertise-client-urls http://$node_ip:2379 \\
--data-dir=$datadir
Restart=always
StartLimitBurst=0

[Install]
WantedBy=multi-user.target
EOF

else
  echo -e "输入内容不正确，终止脚本！！！"
  exit 0
fi

echo -e "------------------加载etcd服务------------------"
sleep 1
systemctl daemon-reload
echo

echo -e "----------启动etcd服务并设置开机自启动----------"
sleep 1
systemctl start etcd
systemctl enable etcd
systemctl status etcd
echo

etcd_active=`systemctl is-active etcd`
if [ $etcd_active == "active" ]
then
  echo
  echo -e "----------------安装完成！请按照安装文档的验证步骤进行检验！---------------"
else
  echo -e "----------------etcd服务安装异常，请排查原因后重新部署！---------------"
  echo
fi
