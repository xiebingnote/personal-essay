# SSE(EventSource)

服务端向客户端单向传递消息，比websocket轻量

github地址：https://github.com/antage/eventsource

    package main
    
    import (
        "fmt"
        "log"
        "net/http"
        "time"

        "github.com/antage/eventsource"
    )
    
    func main() {
        es := eventsource.New(nil, nil)
        es.ConsumersCount()
        defer es.Close()
    
        http.Handle("/events", es)
        go func() {
           for {
              es.SendEventMessage(fmt.Sprintf("now time is %v", time.Now().String()), "", "")
              time.Sleep(time.Second * 2)
           }
        }()
    
        err := http.ListenAndServe(":8090", nil)
        if err != nil {
           log.Fatal(err)
        }
    }

