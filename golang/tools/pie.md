# pie

类型安全：无论是在v1版本还是v2版本的泛型中，都对类型做了限制，所以不会遇到运行时类型错误。

高性能：该库需要跟原生的Go实现一样快，否则该库封装就没有意义。

Nil安全：该库的所有函数都能接收nil参数，并将其视为空切片，而不会引起panic。

对原切片无副作用：所有的函数对传入的切片参数都不会做修改。

    package main

    import (
        "fmt"
        "github.com/elliotchance/pie/v2"
        "strings"
    )
    
    func main() {
        name := pie.Of([]string{"Bob", "Sally", "John", "Jane"}).
           FilterNot(func(name string) bool {
              return strings.HasPrefix(name, "J")
           }).
           Map(strings.ToUpper).
           Last()
    
    fmt.Println(name)
    }

## pie包支持的功能：

1. 切片中的元素是否全部或任意一个满足指定的条件。
2. All函数：判断切片中的元素是否都满足指定的条件。
3. Any函数：判断切片中的元素只要有1个满足指定条件即可。
4. 对切片元素进行排序功能。
5. AreSorted函数：判断切片是否是有序的
6. Sort函数：对切片元素进行排序。
7. SortStableUsing函数：使用指定的条件对切片进行排序，并且具有稳定性。
8. SortUsing函数
9. 对切片中的元素去重。
10. 判断切片中的元素是否不重复的AreUnique函数、去重函数Unique
11. 对切片进行前、后截取。
12. Bottom函数：取切片后n个元素
13. Top函数：取切片前n个元素
14. DropTop函数：丢掉切片的前n个元素，并返回剩余的元素切片
15. 两个或多个切片之间的集合运算
16. Diff函数：计算两个切片中的差集
17. Intersect函数：计算两个或多个切片的交集
18. 切片元素进行算数运算功能（只针对Integer和float类型的切片有效）。
19. Max函数：返回切片中的最大元素
20. Min函数：返回切片中的最小元素
21. Product函数：对切片所有元素进行乘积运算
22. Sum函数：对切片中所有元素进行求和运算
23. Average函数：求所有元素的平均值
24. 对切片中的元素进行数据转换功能：Each、Map、Filter、Flat、Reducer
25. 针对map的操作：
26. Keys函数：获取map的所有键
27. Values函数：获取map的所有值

