#!bin/bash
nsq_tar_name="nsq-1.2.1.linux-amd64.go1.16.6.tar.gz"
nsq_pk_name="nsq-1.2.1.linux-amd64.go1.16.6"

nsq_path="/usr/local"

#------单机安装部署------
read -p "请输入IP地址:" node_ip
echo
echo -e "您输入的IP地址为：$node_ip"
echo
read -p "请输入NSQ集群中的前端管理页面的IP地址：" node_admin
echo
read -p "请核对您输入的IP,确认是否继续执行(Y/N)：" execute 
echo

if [ "$execute" == "Y" ]
then
  
  echo -e "---------------解压nsq压缩包---------------"
  sleep 1
  /bin/tar -zvxf $nsq_tar_name -C $nsq_path
  echo
  
  echo -e "---------------修改nsq目录---------------"
  sleep 1
  mv /usr/local/$nsq_pk_name ${nsq_path}/nsq
  echo
  
echo -e "---------------配置nsqlookupd服务---------------"
sleep 1
echo
cat > /etc/systemd/system/nsqlookupd.service << EOF
[Unit]
Description=nsqlookupd server
After=network.target
Before=nsqd.service

[Service]
Type=simple
User=root
Group=root
ExecStart=${nsq_path}/nsq/bin/nsqlookupd -broadcast-address $node_ip

Restart=always

[Install]
WantedBy=multi-user.target
EOF
  
echo -e "---------------配置nsqd服务---------------"
sleep 1
echo
cat > /etc/systemd/system/nsqd.service << EOF
[Unit]
Description=nsqd server
After=network.target nsqlookupd.service
Before=nsqadmin.service

[Service]
Type=simple
User=root
Group=root
ExecStart=

Restart=always

[Install]
WantedBy=multi-user.target
EOF
  
echo -e "---------------配置nsqadmin服务---------------"
sleep 1
echo
cat > /etc/systemd/system/nsqadmin.service << EOF
[Unit]
Description=nsqadmin server
After=network.target nsqlookupd.service nsqd.service

[Service]
Type=simple
User=root
Group=root
ExecStart=${nsq_path}/nsq/bin/nsqadmin --lookupd-http-address=$node_admin:4161

Restart=always

[Install]
WantedBy=multi-user.target
EOF

else 
  echo -e "终止执行脚本！！！"
  exit 0
fi

