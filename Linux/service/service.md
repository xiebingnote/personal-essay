# Linux Service

## service服务

### 1、创建service文件，指定文件运行的目录：

    参数：WorkingDirectory - 指定运行目录
    ExecStart - 指定启动命令
    Restart - 指定服务重启策略
    RestartSec - 指定重启间隔时间
    User - 指定启动用户
    Group - 指定启动用户组

#### shell 示例：

    cat > /etc/systemd/system/xxx.service << EOF
    [Unit]
    Description=xxx server
    After=network.target
    [Service]
    Type=simple
    User=root
    Group=root
    WorkingDirectory=$workpath
    ExecStart=$SERVICE_NAME
    Restart=always
    RestartSec=5
    
    [Install]
    WantedBy=multi-user.target
    EOF
