# UUID

uuid包基于RFC 4122和DCE 1.1：身份验证和安全服务生成和检查uuid。

git 地址： https://github.com/google/uuid

    package main
    
    import (
        "fmt"

        "github.com/google/uuid"
    )
    
    func main() {
        fmt.Println(uuid.New())
        fmt.Println(uuid.NewString())
    }
