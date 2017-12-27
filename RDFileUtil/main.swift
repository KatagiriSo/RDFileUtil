//
//  main.swift
//  RDFileUtil
//
//  Created by KatagiriSo on 2017/12/27.
//  Copyright © 2017年 Rodhos Soft. All rights reserved.
//

import Foundation

print("Hello, World!")

extension RDFileUtil {
    static func sample() {
        
        showCurrentPath()
        
        createFile(name: "hoge.txt")
        
        print(currentList().map(takeLast(urls:)))
        
        writeFile(name: "hoge.txt", content: "Hello, world!")
        append(name: "hoge.txt", content: "end!")
//        writeFile(name: "hoge.txt", content: "end!")

        
        let r = readFile(name: "hoge.txt").getJust()!
        
        print("\(r)")
        
        let f = RDFile(name: "test")
        
    }
}

RDFileUtil.sample()


