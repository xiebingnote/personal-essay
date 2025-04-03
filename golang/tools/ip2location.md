# ip2location

从IP地址快速查找国家，地区，城市，纬度，经度，邮政编码，时区，ISP，域名，连接类型，IDD代码，地区代码 等各种信息

1. IP2Location.com 是一个免费的IP地址定位服务，可以提供IP地址到地理位置的映射。下载文件数据库到本地
2. 加载文件数据库到代码
3. 调用函数获取 国家/城市/经纬度 等数据


    package main
    
    import (
      "fmt"

       "github.com/ip2location/ip2location-go/v9"
    )
    
    func main() {
       db, err := ip2location.OpenDB("IP2LOCATION-LITE-DB5.BIN")
       if err != nil {
          panic(err)
       }

       res, err := db.Get_all("8.8.8.8")
       if err != nil {
          panic(err)
       }
       fmt.Println(res)
    }
