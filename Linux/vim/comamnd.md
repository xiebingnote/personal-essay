# vim

## 常用命令

### 1、vi/vim全文替换:

    (用def替换文件中所有的abc)
    %s#abc#def#g

### 2、vi/vim局部替换:

    :10,50s#abc#def#g

    如文件内有#，可用/替换：
    :%s/abc/def/g

### 3、vim批量编辑：

    CTRL+v进入编辑模式，上下按键选中行数，左右选中列数：
    删除：选好后按d删除
    编辑：上下选中行数后，按SHIFT+i进入编辑模式，编辑后按两次ESC退出即可

### 4、复制某一行快捷键：yy

### 5、粘贴快捷键：p

### 6、撤销快捷键：u
