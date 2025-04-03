# Bloom filters

go版本布隆过滤器：https://github.com/bits-and-blooms/bloom

Bloom过滤器是集合的简洁/压缩表示，其中主要要求是进行成员查询；即项目是否是集合的成员。当元素确实存在时，Bloom过滤器将始终正确地报告集合
中元素的存在。Bloom过滤器可以使用比原始集合少得多的存储空间，但它允许一些“误报”：它有时可能会报告某个元素在集合中，而不是在集合中。

当你构建时，你需要知道你有多少元素（期望的容量），以及你愿意容忍的期望假阳性率是多少。常见的假阳性率为1%。假阳性率越低，需要的内存就越多。
同样，容量越高，使用的内存就越多。您可以按照以下方式构造Bloom过滤器，该过滤器能够接收100万个元素，误报率为1%。

        filter := bloom.NewWithEstimates(1000000, 0.01) 
        
        // to add a string item, "Love"
        filter.Add([]byte("Love"))
        
        // Similarly, to test if "Love" is in bloom:
        if filter.Test([]byte("Love"))
        
        // to add a uint32 to the filter
        i := uint32(100)
        n1 := make([]byte, 4)
        binary.BigEndian.PutUint32(n1, i)
        filter.Add(n1)

