# MapSet

线程安全和非线程安全的高性能集合

    package main
    
    import (
        "fmt"

        mapset "github.com/deckarep/golang-set/v2"
    )
    
    func main() {
        myset1 := mapset.NewSet[string]()
        myset1.Add("a")
        myset1.Add("b")
        myset1.Add("c")
    
        myset2 := mapset.NewSet[string]()
        myset2.Add("a")
        myset2.Add("b")
    
        myset3 := mapset.NewSet[string]()
        myset3.Add("a")
        myset3.Add("d")
    
        // 集合myset1和myset3的交集
        fmt.Println(myset1.Intersect(myset3))
        // 集合myset1和myset3的差集，返回集合myset1中的元素
        fmt.Println(myset1.Difference(myset3))
        // 集合myset1和myset3的并集
        fmt.Println(myset1.Union(myset3))
        // 集合myset2是否是集合myset1的子集
        fmt.Println(myset2.IsSubset(myset1))
    }
