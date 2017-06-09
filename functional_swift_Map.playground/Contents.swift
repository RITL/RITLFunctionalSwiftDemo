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


