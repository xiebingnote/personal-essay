# Record Note

## 1、docker一段时间后无法访问容器外网络

    Docker daemon服务在启动过程中会检查系统的IP_FORWARD配置项，如果当前系统的IP_FORWARD功能处于停用状态，会帮我们临时启用IP_FORWARD功能，然而临时启用的IP_FORWARD功能会因为其他各种各样的原因失效
    echo 'net.ipv4.ip_forward = 1' >> /usr/lib/sysctl.d/50-default.conf
    sysctl -p /usr/lib/sysctl.d/50-default.conf
