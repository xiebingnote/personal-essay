#!/usr/bin/env bash
nsq_tar_name="nsq-1.2.1.linux-amd64.go1.16.6.tar.gz"
nsq_pk_name="nsq-1.2.1.linux-amd64.go1.16.6"
nsq_path="/usr/local"

read -p "请输入当前服务器的IP地址:" node_ip
echo
echo -e "您输入的IP地址为：$node_ip"
echo
read -p "请核对您输入的IP,确认是否继续执行(Y/N)：" execute 

nsqd_read=`cat nsqconfig |awk 'NR==1'`
nsqlookupd_exec="${nsq_path}/nsq/bin/nsqlookupd -broadcast-address=$node_ip"
nsqd_exec="${nsq_path}/nsq/bin/nsqd $nsqd_read"
nsqadmin_read=`cat nsqconfig |awk 'END {print}'`
nsqadmin_exec="${nsq_path}/nsq/bin/nsqadmin $nsqadmin_read"

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
ExecStart=$nsqlookupd_exec

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
ExecStart=$nsqd_exec

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
ExecStart=$nsqadmin_exec

Restart=always

[Install]
WantedBy=multi-user.target
EOF
  
  else 
    echo -e "终止执行脚本！！！"
    exit 0
  fi 
   
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
cat <<EOF
                      _ooOoo_                       
                     o8888888o                      
                     88" . "88                      
                     (| ^_^ |)                      
                     O\  =  /O                      
                  ____/\`---'\____                   
                .'  \\\\|     |//  \`.                 
               /  \\\\|||  :  |||//  \                
              /  _||||| -:- |||||-  \               
              |   | \\\\\\  -  /// |   |               
              | \_|  ''\---/''  |   |               
              \  .-\__  \`-\`  ___/-. /               
            ___\`. .'  /--.--\  \`. . ___             
         ."" '<  \`.___\_<|>_/___.'  >' "".          
        | | :  \`- \\\`.;\`\ _ /\`;.\`/ - \` : | |         
        \  \ \`-.   \_ __\ /__ _/   .-\` /  /         
========\`-.____\`-.___\_____/___.-\`____.-'======== 
                     \`=---='                      
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        佛祖保佑     永无BUG     永不宕机
EOF
sleep 1
echo
echo -e "----------------安装完成！佛祖曰：请按照安装文档的验证步骤进行检验！---------------"
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
