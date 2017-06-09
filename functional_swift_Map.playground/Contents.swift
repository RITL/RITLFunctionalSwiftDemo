//: Playground - noun: a place where people can play
//: Playground - 高阶函数 - 泛型Map

import UIKit

//最简单的数组变换

let originArray: [Int] = [1,2,3,4,5,6,7]

/// 数组每个元素+1
func increment(array:[Int]) -> [Int]{
    
    var result: [Int] = []
    
    for x in result {
        result.append(x + 1)
    }
    
    return result
}

/// 数组每个元素*2
func double(array:[Int]) -> [Int] {
    
    var result: [Int] = []
    
    for x in array {
        result.append(x * 2)
    }
    
    return result
}

//MARK: 使用
let increment_ = increment(array: originArray)
let double_ = double(array: originArray)


//MARK: 开始变换

/// 对数组进行操作
func compute(array:[Int], transform:(Int) -> Int) -> [Int]{
    
    var result:[Int] = []
    
    for x in array {
        
        result.append(transform(x))
    }
    
    return result
}

func increment1(array:[Int]) -> [Int]{
    
    return compute(array: array, transform: { $0 + 1 })
}

func double2(array:[Int]) -> [Int]{
    
    return compute(array: array, transform: { $0 * 2 })
}


//MARK: 使用
let increment_1 = increment1(array: originArray)
let double_1 = double2(array: originArray)



//MARK: 得到一个布尔型的新数组，表示是否为偶数

//func isEven(array: [Int]) -> [Bool] {

    //出现错误:Cannot convert value of type 'Bool' to closure result type 'Int'
//    return compute(array: array, transform: { $0 % 2 == 0 })
//}


//解决方法1: 新定义一个compute函数 -- 麻烦并且拓展性不够
func compute(array: [Int], transform:(Int) -> Bool) -> [Bool] {
    
    var result: [Bool] = []
    
    for x in array {
        
        result.append(transform(x))
    }
    
    return result
}

let compute0 = compute(array: originArray, transform: { $0 % 2 == 0 })



///MARK: 泛型

//解决方法2: 泛型:

func genericCompute<T>(array: [Int], transform:(Int) -> T) -> [T]{
    
    var result: [T] = []
    
    for x in array {
        
        result.append(transform(x))
    }
    
    return result
}


let genericCompute0 = genericCompute(array: originArray, transform: { $0 % 2 == 0 })


//缺点: 只能处理Int类型的数组

//优化:

func map<Element,T>(_ array:[Element], transform:(Element) -> T) -> [T] {
    
    var result: [T] = []
    
    for x in array {
        
        result.append(transform(x))
    }
    
    return result
}


func genericCompute2<T>(array: [Int], transform:(Int) -> T) -> [T] {
    
    return map(array, transform: transform)
}


let genericCompute1 = genericCompute2(array: originArray, transform: { $0 % 2 == 0 })



///MARK: 对Array进行拓展
extension Array {
    
    func map<T>(_ transform:(Element) -> T) -> [T] {
        
        var result: [T] = []
        
        for x in self {
            
            result.append(transform(x))
        }
        
        return result
    }
}

///使用map函数持续优化genericCompute方法
func genericCompute3<T>(array: [Int], transform:(Int) -> T) -> [T] {
    
    return array.map(transform)
}



