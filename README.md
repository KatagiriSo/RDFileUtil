# RDFileUtil
Swift FileManager Util

This is a simple file manage utility class. 

sample

```swift
        createFile(name: "hoge.txt")
                
        writeFile(name: "hoge.txt", content: "Hello, world!")
        
        append(name: "hoge.txt", content: "end!")
        
        let r = readFile(name: "hoge.txt").getJust()!
        
        print("\(r)")
```

```cterm
Hello, world!
end!
```



