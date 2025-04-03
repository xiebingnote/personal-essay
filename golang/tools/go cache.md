# go cache

golang的缓存库。

支持可擦除缓存、LFU、LRU和ARC

协程安全

支持驱逐、清除和添加条目的事件处理程序 (可选)

缓存不存在的时候自动加载缓存 (可选)

github地址: https://github.com/bluele/gcache

LRU(Least Recently User): 最近最少使用算法,根据数据的历史访问记录来进行淘汰数据

LFU(Least Frequently Used): 最近最不常用算法,根据数据的历史访问频率来淘汰数据

ARC(Adaptive Replacement Cache): 自适应缓存替换算法,它结合了LRU与LFU,来获得可用缓存的最佳使用。

    package main
    
    import (
        "fmt"

        "github.com/bluele/gcache"
    )
    
    func main() {
        gc := gcache.New(10).LRU().Build()
        gc.Set("key", "value")
        value, err := gc.Get("key")
        if err != nil {
           panic(err)
        }
        fmt.Println(value)
    
        gc1 := gcache.New(10).LFU().Build()
        gc1.Set("k1", "v1")
        v, err := gc1.Get("k1")
        if err != nil {
           panic(err)
        }
        fmt.Println(v)
    
        gc2 := gcache.New(10).ARC().Build()
        gc2.Set("k2", "v2")
        v1, err := gc2.Get("k2")
        if err != nil {
           panic(err)
        }
        fmt.Println(v1)
    }


