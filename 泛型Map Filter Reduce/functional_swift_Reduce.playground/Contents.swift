//: Playground - noun: a place where people can play
//: Playground - 高阶函数 - 泛型之Reduce

import UIKit

/// 计算所有整型值的和
func sum(intergers:[Int]) -> Int {
    
    var result: Int = 0
    
    for x in intergers {
        result += x
    }
    
    return result
}

let sum1 = sum(intergers: [1,2,3,4]) //10


/// 计算所有整型值的乘积
func product(intergers:[Int]) -> Int {
    
    var result: Int = 1
    
    for x in intergers {
        
        result *= x
    }
    
    return result
}

let product1 = product(intergers: [1,2,3,4]) //24


/// 连接所有的字符串
func concatenate(strings:[String]) -> String {
    
    var result: String = ""
    
    for string in strings {
        
        result += string
    }
    
    return result
}

let concatenate1 = concatenate(strings: ["I","study","Swift"])


/// 连接数组的所有字符串并插入一个单独的首行以及每一项后面追加一个换行符
func prettyPrint(strings: [String]) -> String {
    
    var result: String = ""
    
    for string in strings {
        
        result = " " + result + string + "\n"
    }
    
    return result
}

let prettyPrint1 = prettyPrint(strings: ["I","study","Swift"])



/// 使用Array的extension进行拓展
extension Array {
    
    /// 初始值，变换函数
    func reduce<T>(_ initial: T,combine:(T,Element) -> T) -> T {
        
        var result = initial
        
        for x in self {
            result = combine(result,x)
        }
        
        return result
    }
    
}


///MARK: 使用reduce定义所有的函数
func sumUsingReduce(intergers:[Int]) -> Int {
    
//    return intergers.reduce(0, combine: { result,x in result + x )})
//    return intergers.reduce(0){result,x in result + x }
    return intergers.reduce(0){ $0 + $1 }
}

func productusingReduce(intergers:[Int]) -> Int {
    
    return intergers.reduce(1, combine: *)
}

func concatUsingReduce(strings: [String]) -> String {
    
    return strings.reduce("", combine: +)
}


/// 假设有一个数组，它的每一项都是数组，展开为一个数组，使用for
func flatten<T>(_ xss: [[T]]) -> [T] {
    
    var result: [T] = []
    
    for xs in xss {
        
        result += xs
    }
    
    return result
}

//使用reduce
func fattenUsingReduce<T>(_ xss:[[T]]) -> [T] {
    
//    return xss.reduce([], combine:{result,xs in result + xs })
//    return xss.reduce([]){ result, xs in result + xs }
    return xss.reduce([], combine: +)
}


///MARK: Important!!!!

/// 使用reduce重新定义map & filter

extension Array {
    
    /// 使用reduce重新定义map
    func mapUsingReduce<T>(_ transform:(Element) -> T) -> [T]{
        
        return self.reduce([], combine: { result, element in
            
            return result + [transform(element)]
        })
    }
    
    
    /// 使用reduce重新定义filter
    func filterUsingReduce(_ includeElement:(Element) -> Bool) -> [Element]{
        
        return self.reduce([], combine: { result, element in
            
            return includeElement(element) ? result + [element] : result
        })
    }
    
}
