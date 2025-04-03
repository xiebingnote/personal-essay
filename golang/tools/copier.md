# copier

处理不同类型之间的赋值：

调用同名方法为字段赋值；

以源对象字段为参数调用目标对象的方法，从而为目标对象赋值（当然也可以做其它的任何事情）；

将切片赋值给切片（可以是不同类型哦）；

将结构体追加到切片中。

git地址：github.com/jinzhu/copier

    package main

    import (
        "fmt"
        "github.com/jinzhu/copier"
    )
    
    type User struct {
        Name string
        Age  int
        Tail int
    }
    
    type Employee struct {
        Name string
        Age  int
        Role string
    }
    
    func main() {
        // 结构体赋值
        user := User{Name: "dj", Age: 18, Tail: 1}
        employee := Employee{}
    
        copier.Copy(&employee, &user)
        fmt.Printf("%#v\n", employee)
    
        // 切片赋值
        users := []User{
           {Name: "dj", Age: 18},
           {Name: "dj2", Age: 18},
        }
        employees := []Employee{}
    
        copier.Copy(&employees, &users)
        fmt.Printf("%#v\n", employees)
    
        // 结构体复制到切片
        user1 := User{Name: "dj", Age: 18}
        employees1 := []Employee{}
    
        copier.Copy(&employees1, &user1)
        fmt.Printf("%#v\n", employees1)
    }
