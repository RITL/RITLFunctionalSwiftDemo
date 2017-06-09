//: Playground - noun: a place where people can play
//: Playground -  高阶函数 - 过滤器Filter


import UIKit

let exampleFiles = ["README.md","Helloworld.swift","FlappyBrid.swift"]

/// 通过遍历得到所有包含.swift的文件名
func getSwiftFiles(in files:[String]) -> [String] {
    
    var result: [String] = []
    
    for file in files {
        
        if file.hasSuffix("swift") {//swift后缀
            result.append(file)
        }
    }
    
    return result
}

let swiftFiles = getSwiftFiles(in: exampleFiles)

///MARK: 通过Array的extension进行拓展

extension Array {
    
    func filter(_ includeElement:(Element) -> Bool) -> [Element] {
        
        var result: [Element] = []
        
//        for x in self { //麻烦的循环?
//            if includeElement(x) {
//                result.append(x)
//            }
//        }
        
        for x in self where includeElement(x) {
            result.append(x)
        }
        
        return result
    }
}

// 优化 getSwiftFiles2 方法
func getSwiftFiles2(in files:[String]) -> [String] {
    
    return files.filter { file in file.hasSuffix(".swift") }
}

let swiftFiles1 = getSwiftFiles2(in: exampleFiles)
