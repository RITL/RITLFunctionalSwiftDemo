//: Playground - noun: a place where people can play
//: Playground - 可选值

import UIKit


let cities = ["Paris" : 2241, "Madrid" : 3165, "Amsterdam":827, "Berlin":3562]

//可支持泛型
let cities1: Dictionary<String, Int> = ["Paris" : 2241]
let cities2: [String : Int] = ["Paris" : 2241]


let madridPopulation: Int? = cities["Madrid"]

//验证 --- unsafe!
if madridPopulation != nil {
    
    print("存在Madrid")
    
} else {
    
    print("不存在Madrid")
}


if let _ = cities["Madrid"] {
    
    print("存在Madrid")
    
} else {
    
   print("不存在Madrid")
    
}


infix operator ??

func ??<T>(optional:T?, defaultValue:T) -> T {
    
    if let x = optional {
        
        return x
        
    } else {
        
        return defaultValue 
    }
}



