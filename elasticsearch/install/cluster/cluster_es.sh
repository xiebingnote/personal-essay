#!/usr/bin/env bash
es_tar_name="elasticsearch-8.2.3-linux-x86_64.tar.gz"
es_pk_name="elasticsearch-8.2.3"
es_user="es"

cluster_name="cluster_es"
es_path="/usr/local"
path_log="${es_path}/elasticsearch/logs"
path_data="${es_path}/elasticsearch/data"
limit="/etc/security/limits.conf"
nproc="/etc/security/limits.d/20-nproc.conf"
sysctl="/etc/sysctl.conf"
esconf="${es_path}/elasticsearch/config/elasticsearch.yml"
esjvm="${es_path}/elasticsearch/config/jvm.options"

esconf_read=`cat esconfig`
echo -e "您填写的esconf文件内容为："
echo
echo -e "$esconf_read"
echo
read -p "请核对您输入的内容,确认是否继续执行(Y/N)：" execute 
echo

if [ "$execute" == "Y" ]
then
  echo -e "---------------解压elasticsearch压缩包---------------"
  sleep 1
  /bin/tar -zvxf $es_tar_name -C $es_path
  echo
  
  echo -e "---------------修改elasticsearch目录---------------"
  sleep 1
  mv ${es_path}/$es_pk_name ${es_path}/elasticsearch
  echo

  if [ ! -d "$path_data" ] ; then
    mkdir -p $path_data
  fi

  if ! id -u ${es_user} >/dev/null 2>&1 ; then
    echo -e "创建用户：$es_user"
    sleep 1
    useradd $es_user
    echo
  else
    echo -e "用户：$es_user 已创建"
    sleep 1
    echo
  fi
  
  #备份文件
  echo -e "-------------备份limit.conf文件------------"
  /bin/cp $limit ${limit}.bak
  echo
  sleep 1

  echo -e "-------------备份nproc.conf文件------------"
  /bin/cp $nproc ${nproc}.bak
  echo
  sleep 1

  echo -e "-------------备份sysctl.conf文件-----------"
  /bin/cp $sysctl ${sysctl}.bak
  echo
  sleep 1

echo -e "---------------配置limit服务---------------"
sleep 1
cat >> $limit <<EOF
* soft nofile 65536
* hard nofile 65536
* soft nproc 4096
* hard nproc 4096
EOF
echo

echo -e "---------------配置nproc服务---------------"
sleep 1
cat >> $nproc <<EOF
es soft nofile 65536
es hard nofile 65536
* hard nproc 4096
EOF
echo

echo -e "---------------配置sysctl服务---------------"
sleep 1
cat >> $sysctl <<EOF
vm.max_map_count=655360
EOF
echo

echo -e "---------------重新加载sysctl服务---------------"
sleep 1
echo -e "服务加载后输出内容："
sysctl -p
echo


echo -e "---------------更改elasticsearch配置文件---------------"
sleep 1
cat >> $esconf <<EOF
#数据data和log目录
path:
  data: $path_data
  logs: $path_log
#集群名称
cluster.name: $cluster_name 
#选举master资格
node.roles: [master,data]
#是否开启安全认证，如开启，必须配置transport和http的证书
xpack.security.enabled: false
#是否开启http的ssl认证
xpack.security.http.ssl:
  enabled: false
#是否开启transport的认证
xpack.security.transport.ssl:
  enabled: false
#允许跨域
http.cors.enabled: true
http.cors.allow-origin: "*"
http.cors.allow-headers: Authorization,X-Requested-With,Content-Type,Content-Length
bootstrap.memory_lock: true
$esconf_read
EOF
 
cat >> $esjvm <<EOF
-Xms4g
-Xmx4g
EOF
echo

    echo -e "---------------更改elasticsearch文件夹所属用户---------------"
    sleep 1
    chown -R $es_user:$es_user ${es_path}/elasticsearch
    echo

  else
    echo -e "终止执行脚本！！！"
    exit 0
  fi

echo -e "---------------配置elasticsearch服务---------------"
sleep 1
echo
cat > /etc/systemd/system/elasticsearch.service << EOF
[Unit]
Description=elasticsearch server
After=network.target
[Service]
Type=simple
User=$es_user
Group=$es_user
LimitNOFILE=100000
LimitNPROC=100000
ExecStart=${es_path}/elasticsearch/bin/elasticsearch
Restart=always

[Install]
WantedBy=multi-user.target
EOF

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
sleep 1

es_active=`systemctl is-active elasticsearch`
if [ $es_active == "active" ]
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
        佛祖保佑                  永不宕机
EOF
sleep 1
echo
echo -e "----------------安装完成！佛祖曰：请按照安装文档的验证步骤进行检验！---------------"
else
  echo -e "----------------elasticsearch服务安装异常，请排查原因后重新部署！---------------"
  echo
fi
