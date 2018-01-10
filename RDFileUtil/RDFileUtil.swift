//
//  RDFileUtil.swift
//  RDFileUtil
//
//  Created by KatagiriSo on 2017/12/27.
//  Copyright © 2017年 Rodhos Soft. All rights reserved.
//

// ooo

import Foundation

enum Maybe<T> {
    case just(T)
    case error(Error)
    
    func getJust() -> T? {
        switch self {
        case .just(let t):
            return t
        default:
            return nil
        }
    }
    
    func getError() -> Error? {
        switch self {
        case .error(let e):
            return e
        default:
            return nil
        }
    }
    
    func get() -> (T?,Error?) {
        return (self.getJust(), self.getError())
    }
}

extension Maybe {
    func flatMap<U>(_ f:(T)->Maybe<U>) -> Maybe<U> {
        switch self {
        case .just(let t):
            return f(t)
        case .error(let e):
            return Maybe<U>.error(e)
        }
    }
    
    func map<U>(_ f:(T) -> U) -> Maybe<U> {
        switch self {
        case .just(let t):
            return Maybe<U>.just(f(t))
        case .error(let e):
            return Maybe<U>.error(e)
        }
    }
    
}

protocol IShow {
    func show()
}

extension Maybe where T : CustomStringConvertible {
    var description : String {
        get {
            switch self {
            case .error(let e):
                return e.localizedDescription
            case .just(let t):
                return t.description
            }
        }
    }
    
    func show() {
        print(self.description)
    }
}




struct RDFileUtil {
    
    static func current() -> URL {
        let fm = FileManager()
        let path = fm.currentDirectoryPath
        return URL(fileURLWithPath: path)
    }
    
    static func showCurrentPath() {
        print(current().absoluteString)
    }
    
    static func list(path:URL) -> Maybe<[URL]> {
        let fm = FileManager()
        do {
            let pathStr = path.path
            let contents = try fm.contentsOfDirectory(atPath: pathStr)
            let urls = contents.map { path.appendingPathComponent($0)}
            return Maybe.just(urls)
        } catch let e {
            return Maybe.error(e)
        }
    }
    
    static func isFile(path:URL) -> Bool {
        let fm = FileManager()
        var isDir : ObjCBool = false
        guard fm.fileExists(atPath: path.path, isDirectory: &isDir) else {
            return false
        }
        if isDir.boolValue {
            return false
        } else {
            return true
        }
    }
    
    
    static func fileList(path:URL) -> Maybe<[URL]> {
        return list(path: path).map { $0.filter { isFile(path: $0) }}
    }
    
    
    static func takeLast(urls:[URL]) -> [String] {
        return urls.map { $0.lastPathComponent }
    }
    
    static func currentList() -> Maybe<[URL]> {
        let path = current()
        return list(path: path)
    }
    
    static func createFile(name:String, relativeURL:URL = current()) {
        createFile(url: relativeURL.appendingPathComponent(name))
    }

    
    static func createFile(url:URL) {
        let fm = FileManager()
        fm.createFile(atPath: url.path, contents: nil, attributes: nil)
    }
    
    static func writeFile(name:String, relativeURL:URL = current(), content:String) {
        print(#function + " " + name)
        writeFile(url: relativeURL.appendingPathComponent(name), content:content)
    }
    
    static func writeFile(url:URL, content:String) {
        try! content.write(toFile: url.path
            , atomically: true, encoding: .utf8)
    }
    
    static func readFile(name:String, relativeURL:URL = current()) -> Maybe<String> {
        return readFile(url: relativeURL.appendingPathComponent(name))
    }
    
    static func readFile(url:URL) -> Maybe<String> {
        do {
            let text = try String(contentsOfFile:url.path, encoding:.utf8)
            return Maybe.just(text)
        } catch let e {
            return Maybe.error(e)
        }
    }
    
    static func append(name:String, relativeURL:URL = current(), content:String) {
        append(url: relativeURL.appendingPathComponent(name), content: content)
    }
    
    static func append(url:URL, content:String) {
        do {
            let fileHandle = try FileHandle(forWritingTo: url)
            fileHandle.seekToEndOfFile()
            let text = "\n" + content
            fileHandle.write(text.data(using: String.Encoding.utf8)!)
        } catch let error as NSError {
            print("appendText failed: \(error)")
        }
    }

}
