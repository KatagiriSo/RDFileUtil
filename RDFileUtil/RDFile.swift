//
//  RDFile.swift
//  RDFileUtil
//
//  Created by KatagiriSo on 2017/12/27.
//  Copyright © 2017年 Rodhos Soft. All rights reserved.
//

import Foundation

enum Node<T> {
    case element(T)
    indirect case composite([Node<T>])
    
    func getElement() -> T? {
        switch self {
        case .element(let t):
            return t
        default:
            return nil
        }
    }
    
    func getComposite() -> [Node<T>]? {
        switch self {
        case .composite(let c):
            return c
        default:
            return nil
        }
    }
    
    func append(_ t:T) -> Node<T> {
        switch self {
        case .element(let e):
            let es = [e,t].map { Node.element($0)}
            return Node.composite(es)
        case .composite(let nodes):
            return Node.composite(nodes + [Node.element(t)])
        }
    }
    
    func append(_ n:Node<T>) -> Node<T> {
        switch self {
        case .element(let t):
            switch n {
            case .element(let ne):
                let es = [t,ne].map { Node.element($0)}
                return Node.composite(es)
            case .composite(let comps):
                return Node.composite([self] + comps)
            }
        case .composite(let comps):
            return Node.composite(comps + [n])
        }
    }
}

typealias StringNode = Node<String>

extension Node where T == String {
    func display() -> String {
        switch self {
        case .element(let s):
            return s
        case .composite(let nodes):
            let ss = nodes.map { $0.display() }.joined(separator: "\n")
            return ss
        }
    }
}

class RDFile {
    
    let url:URL
    
    init(url:URL) {
        self.url = url
        self.texts = StringNode.element("x")
        self.texts = self.texts?.append("ok")
        self.texts = self.texts?.append("x")
        self.texts = self.texts?.append("y")
        
        print(self.texts!.display())

    }
    
    var texts:StringNode? = nil
    
    convenience init(name:String, relativeURL:URL = RDFileUtil.current()) {
        self.init(url: relativeURL.appendingPathComponent(name))
    }
    
    
}
