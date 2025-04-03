# Concurrent Map

并发读写，分片带锁map，性能比sync.Map高，标准库中的sync.Map是专为append-only场景设计的。

git 地址：https://github.com/orcaman/concurrent-map/tree/master

通过对内部map进行分片，降低锁粒度，从而达到最少的锁等待时间(锁冲突)

    package main
    
    import (
           "fmt"
           "github.com/orcaman/concurrent-map/v2"
    )
    
    func main() {
           m := cmap.New[string]()
           m.Set("key", "value")
    
    if v, ok := m.Get("key"); ok {
                 fmt.Println(v)
           }
    
    fmt.Println(m.Count())
           fmt.Println(m.IsEmpty())
           fmt.Println(m.Has("key"))
           fmt.Println(m.GetShard("key"))
    }

