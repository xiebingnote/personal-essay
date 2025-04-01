# Centos7 开机重置root密码

## 步骤：

### 1、 在启动GRUB菜单中选择编辑选项，按键 “e” 进入编辑;

![img.png](image/img.png)

### 2、修改“ro”为“rw init=/sysroot/bin/bash”

![img_1.png](image/img_1.png)

### 3、按ctrl + x 进入单用户模式

![img_2.png](image/img_2.png)

### 4、输入chroot /sysroot 命令进入系统

![img_3.png](image/img_3.png)

### 5、输入passwd root 命令重置root密码

![img_4.png](image/img_4.png)

### 6、输入 touch /.autorelabel 命令更新SELinux信息

![img_5.png](image/img_5.png)

##3 7、输入 exit 退出 chroot

![img_6.png](image/img_6.png)

### 8、输入reboot重启系统

![img_7.png](image/img_7.png)

### 9、登录系统测试
