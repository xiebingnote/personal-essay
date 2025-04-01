# Shell

## 常用命令

### 1、shell中解决for循环处理文本中空格的问题：修改默认分隔符

    IFS=$'\n'
    OLDIFS="$IFS"

### 2、判断字符串是否相等

    A="$1"
    B="$2"
    if [ "$A" = "$B" ];then
      echo "[ = ]"
    fi

#### 或条件判断（注意[]前后的空格）：

    read -p "请核对您输入的网卡,确认是否继续执行(Y/N)：" execute
    echo
    if [[ "$execute" == "Y" || "$execute" == "y" ]]
      then
      echo -e "11111"
    fi
    
    ########################################################
    
    read -p "请核对您输入的网卡,确认是否继续执行(Y/N)：" execute
    echo
    if [ "$execute" == "Y" ] || [ "$execute" == "y" ]
      then
      echo -e "11111"
    fi

### 3、变量定义

    var="xxxxx"
    path_es="/usr/local"
    
    变量在另一个变量中使用
    path_log="${path_es}/elasticsearch/logs"

### 4、命令当做变量

    var=$(要执行的命令)

### 5、去除双引号

    sed 's/\"//g'

### 6、向文件中追加内容，可在追加内容中直接使用定义的变量

    cat >> $systcl <<EOF
    vm.max_map_count=655360
    path: $path_es
    EOF

### 7、tar命令

    如果不能在脚本中直接使用tar命令，更改为：/bin/tar 即可

### 8、删除文件最后一行：

    sed -i '$d' 文件名

### 9、删除最后n行,n为数字

    sed -i "$(($(wc -l <aa.text)-n+1)),$ d" aa.text

### 10、删除某一行

    #找到broker.id=0所在的行
    strbroker="broker.id"
    line1=`sed -n '/'$strbroker'/=' $kafka_server_properties`
    
    #删除该行
    sed -i "$line1 d" $kafka_server_properties

### 11、函数传递参数

    #!/bin/bash

    # 日志函数，接受一个参数
    log() {
        local log_message="$1"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $log_message"
    }

    # 示例函数，接受多个参数
    process_input() {
        local arg1="$1"
        local arg2="$2"
        local arg3="$3"

        log "用户输入的参数是: arg1=$arg1, arg2=$arg2, arg3=$arg3"
        # 在这里可以处理输入的参数
    }

    # 读取用户输入，使用多个变量来接收输入
    read -p "请输入参数1：" user_input1
    read -p "请输入参数2：" user_input2
    read -p "请输入参数3：" user_input3

    # 调用函数并将用户输入的参数传递给它
    process_input "$user_input1" "$user_input2" "$user_input3"
    
    # 继续执行脚本的其他操作
    
    log "脚本执行完成"

### 12、Switch case实现：

    #!/bin/bash

    # 读取用户输入
    read -p "请输入一个选项 (A, B, C)：" option
    
    # 使用 case 语句进行条件判断
    case "$option" in
        "A" | "a")
            echo "您选择了 A"
            # 在这里添加 A 选项的处理逻辑
            ;;
        "B" | "b")
            echo "您选择了 B"
            # 在这里添加 B 选项的处理逻辑
            ;;
        "C" | "c")
            echo "您选择了 C"
            # 在这里添加 C 选项的处理逻辑
            ;;
        *)
            echo "无效的选项"
            # 在这里添加处理无效选项的逻辑
            ;;
    esac

    # 继续执行脚本的其他操作
    echo "脚本执行完成"
