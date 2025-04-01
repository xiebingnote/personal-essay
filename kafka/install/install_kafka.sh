#!/usr/bin/env bash
kafka_tar_name="kafka_2.11-1.1.0.tgz"
kafka_pk_name="kafka_2.11-1.1.0"
kafka_path="/opt"

#zookeeper的master节点和slave节点之间的通信端口,默认是2888
zk_internal_port="2888"
#zookeeper的leader选举的端口,集群刚启动的时候选举或者leader挂掉之后进行新的选举的端口默认是3888
zk_election_port="3888"
#zookeeper的连接端口
kafka_zkport="2181"
#kafka对外提供服务的默认的端口
kafka_port="9092"

zookeeper_properties="${kafka_path}/kafka/config/zookeeper.properties"
kafka_server_properties="${kafka_path}/kafka/config/server.properties"
zkdatadir="${kafka_path}/kafka/zookeeper"
zkdatalogdir="${kafka_path}/kafka/logs/zookeeper"
myid="${zkdatadir}/myid"
kafka_logpath="${kafka_path}/kafka/logs/kafka"

echo -e "------请确认当前是单机部署还是集群部署------"
echo
echo -e "------请注意：目前此脚本仅支持 3 节点集群！------"
echo
echo -e "单机部署节点数请输入：1，集群部署节点数请输入：3"
echo
read -p "请输入节点数：" number
echo

#------单机安装部署------
if [ "$number" == "1" ]
then 
  read -p "请输入IP地址:" node_ip
  echo
  echo -e "您输入的IP地址为：$node_ip"
  echo
  read -p "请核对您输入的IP,确认是否继续执行(Y/N)：" execute 
  
  if [ "$execute" == "Y" ]
  then
    
    echo -e "---------------解压kafka压缩包---------------"
    sleep 1
    /bin/tar -zvxf $kafka_tar_name -C $kafka_path
    echo
    
    echo -e "---------------修改kafka目录---------------"
    sleep 1
    mv ${kafka_path}/$kafka_pk_name ${kafka_path}/kafka
    echo

    if [ ! -d "$zkdatadir" ]; then
      mkdir -p "$zkdatadir"
    fi

    if [ ! -d "$kafka_logpath" ]; then
      mkdir -p "$kafka_logpath"
    fi
    
    #创建myid文件
    echo "0" > $myid
    
    echo -e "----------设置 zookeeper 配置文件----------"
    sleep 1
    #找到dataDir所在的行
    str="dataDir="
    line=`sed -n '/'$str'/=' $zookeeper_properties`
    #删除该行
    sed -i "$line d" $zookeeper_properties

cat >> $zookeeper_properties << EOF

dataDir=$zkdatadir
dataLogDir=$zkdatalogdir
clientPort=$kafka_zkport
#设置连接参数，添加如下配置
tickTime=2000
initLimit=10
syncLimit=5
EOF
echo

    echo -e "----------设置 kafka 配置文件----------"
    sleep 1
    #找到broker.id=0所在的行
    strbroker="broker.id"
    line1=`sed -n '/'$strbroker'/=' $kafka_server_properties`
    #删除该行
    sed -i "$line1 d" $kafka_server_properties
    
    #找到log.dirs所在的行
    strlog="log.dirs"
    line2=`sed -n '/'$strlog'/=' $kafka_server_properties`
    #删除该行
    sed -i "$line2 d" $kafka_server_properties
    
    #找到zookeeper.connect=localhost所在的行
    strcon="zookeeper.connect=localhost"
    line3=`sed -n '/'$strcon'/=' $kafka_server_properties`
    #删除该行
    sed -i "$line3 d" $kafka_server_properties

#配置kafka的server文件
cat >> $kafka_server_properties << EOF

broker.id=0
log.dirs=$kafka_logpath
zookeeper.connect=$node_ip:$kafka_zkport
listeners=PLAINTEXT://$node_ip:$kafka_port
EOF
echo

    else 
      echo -e "终止执行脚本！！！"
      exit 0
    fi

elif [ "$number" == "3" ]
then
  #---------------集群部署---------------
  echo -e "确认当前服务器为集群第几节点，输入编号：1，2，3，后续输入的节点地址，在其他机器上必须保持一致！！！"
  echo
  read -p "请输入集群节点1的IP地址(主节点):" node1_ip
  read -p "请输入集群节点2的IP地址:" node2_ip
  read -p "请输入集群节点3的IP地址:" node3_ip
  echo
  read -p "请确认当前机器是集群中的第几节点（1,2,3）：" node_number
  echo
  
  listeners="PLAINTEXT://$node1_ip:$kafka_port"

  if [ "$node_number" == "1" ]
  then
    echo -e "当前机器为第1节点"
    echo
  elif [ "$node_number" == "2" ]
  then 
    echo -e "当前机器为第2节点"
    listeners="PLAINTEXT://$node2_ip:$kafka_port"
    echo
  elif [ "$node_number" == "3" ]
  then
    echo -e "当前机器为第3节点"
    listeners="PLAINTEXT://$node3_ip:$kafka_port"
    echo
  else
    echo -e "集群节点编号输入不正确！！！退出安装！！！"
    exit 0
  fi

  echo -e "您输入的集群IP地址为：$node1_ip，$node2_ip ，$node3_ip"
  echo
  read -p "请核对您输入的IP,确认是否继续执行(Y/N)：" execute 
  echo

  if [ "$execute" == "Y" ]
  then
    echo -e "---------------解压kafka压缩包---------------"
    sleep 1
    /bin/tar -zvxf $kafka_tar_name -C $kafka_path
    echo

    echo -e "---------------修改kafka目录---------------"
    sleep 1
    mv ${kafka_path}/$kafka_pk_name ${kafka_path}/kafka
    echo
  
    if [ ! -d "$zkdatadir" ]; then
      mkdir -p "$zkdatadir"
    fi
    
    if [ ! -d "$kafka_logpath" ]; then
      mkdir -p "$kafka_logpath"
    fi
     
    #创建myid文件
    echo $node_number > $myid
    
    echo -e "----------设置 zookeeper 配置文件----------"
    sleep 1
    #找到dataDir所在的行
    str="dataDir="
    line=`sed -n '/'$str'/=' $zookeeper_properties`
    #删除该行
    sed -i "$line d" $zookeeper_properties

#配置zookeeper
cat >> $zookeeper_properties << EOF

dataDir=$zkdatadir
dataLogDir=$zkdatalogdir
#设置连接参数，添加如下配置
tickTime=2000
initLimit=10
syncLimit=5
#设置broker Id的服务地址
server.1=$node1_ip:$zk_internal_port:$zk_election_port
server.2=$node2_ip:$zk_internal_port:$zk_election_port
server.3=$node3_ip:$zk_internal_port:$zk_election_port
EOF
echo

    echo -e "----------设置 kafka 配置文件----------"
    sleep 1
    #找到broker.id=0所在的行
    strbroker="broker.id"
    line1=`sed -n '/'$strbroker'/=' $kafka_server_properties`
    #删除该行
    sed -i "$line1 d" $kafka_server_properties
    
    #找到log.dirs所在的行
    strlog="log.dirs"
    line2=`sed -n '/'$strlog'/=' $kafka_server_properties`
    #删除该行
    sed -i "$line2 d" $kafka_server_properties
    
    #找到zookeeper.connect=localhost所在的行
    strcon="zookeeper.connect=localhost"
    line3=`sed -n '/'$strcon'/=' $kafka_server_properties`
    #删除该行
    sed -i "$line3 d" $kafka_server_properties

#配置kafka的server文件
cat >> $kafka_server_properties << EOF

broker.id=$node_number
log.dirs=$kafka_logpath
zookeeper.connect=$node1_ip:$kafka_zkport,$node2_ip:$kafka_zkport
listeners=$listeners
EOF
echo

  else
    echo -e "终止执行脚本！！！"
    exit 0
  fi

else
  echo -e "输入内容不正确，终止脚本！！！"
  exit 0
fi

echo -e "---------------配置Zookeeper服务---------------"
sleep 1
echo
cat > /etc/systemd/system/zookeeper.service  << EOF
[Unit]
Description=Zookeeper server
After=network.target  
Before=kafka.service
[Service]
Type=simple
User=root
Group=root
ExecStart=${kafka_path}/kafka/bin/zookeeper-server-start.sh ${kafka_path}/kafka/config/zookeeper.properties
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo -e "---------------配置Kafka服务---------------"
sleep 1
echo
cat > /etc/systemd/system/kafka.service  << EOF
[Unit]
Description=Apache Kafka server (broker)
After=network.target  zookeeper.service
[Service]
Type=simple
User=root
Group=root
ExecStart=${kafka_path}/kafka/bin/kafka-server-start.sh ${kafka_path}/kafka/config/server.properties
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo -e "---------------加载Kafka和Zookeeper服务---------------"
sleep 1
systemctl daemon-reload
echo  

echo -e "---------------启动Zookeeper服务并设置开机自启动---------------"
sleep 1
systemctl start zookeeper
systemctl enable zookeeper
systemctl status zookeeper
echo

echo -e "---------------启动Kafka服务并设置开机自启动---------------"
sleep 1
systemctl start kafka
systemctl enable kafka
systemctl status  kafka
echo

zookeeper_active=`systemctl is-active zookeeper`
kafka_active=`systemctl is-active kafka`

if [ $zookeeper_active == "active" ] && [ $kafka_active == "active" ]
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
  if [ ! $zookeeper_active == "active" ]
  then
   echo -e "----------------zookeeper服务安装异常，请排查原因后重新部署！---------------"
   echo
  fi

  if [ ! $kafka_active == "active" ]
  then
   echo -e "----------------kafka服务安装异常，请排查原因后重新部署！---------------"
   echo
  fi
fi
