# Git Usage

## 1、git merge 用法：

### 一、开发分支（dev）上的代码达到上线的标准后，要合并到 master 分支

    git checkout dev
    git pull
    git checkout master
    git merge dev
    git push -u origin master

### 二、当master代码改动了，需要更新开发分支（dev）上的代码

    git checkout master
    git pull
    git checkout dev
    git merge master

## 2、git merge 回退代码：

    第一步：git checkout到你要恢复的那个分支上
    git checkout develop

    第二步：git reflog查出要回退到merge前的版本号
    git reflog

    第三步：git reset --hard [版本号]就回退到merge前的代码状态了
    git reset --hard f82cfd2

## 3、git忽略https证书：

    git config --global http.sslVerify "false"

## 4、git保存账户密码：

    git config --global credential.helper store

## 5、git设置仓库：

### 1：新增仓库

    git remote add http://xxx

### 2：更换仓库

    git remote set-url http://xxx

## 6、git 回退

    1：git add . 回退
    git reset .

    2：git commit 回退
    git reset HEAD^

## 7、reset过多恢复：

    git reflog
    找到commitID后
    git reset --hard abc123

## 8、.gitignore文件内容不生效

    原因是因为在git忽略目录中，新建的文件在git中会有缓存，如果某些文件已经被纳入了版本管理中，就算是在.gitignore中已经声明了忽略路径也是不起作用的，应该先把本地缓存删除，然后再进行git的提交，这样就不会出现忽略的文件了。
    git rm -f --cached .
    git add .
    git commit -m "update xxx"
    git push

## 9、git 报错：you have not concluded your merge (MERGE_HEAD exists). Please, commit your changes before you

    造成这个问题的原因是：没有拉取最新代码。

    解决办法:保留本地的更改,中止合并->重新合并->重新拉取
    git merge --abort //中止合并
    git reset --merge //撤销合并
    git pull //拉去代码

