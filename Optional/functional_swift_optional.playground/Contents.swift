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



infix operator ???

func ???<T>(optional:T?, defaultValue:T) -> T {
    
    if let x = optional {
        
        return x
        
    } else {
        
        return defaultValue
    }
}

let cache: Dictionary<String, Int> = ["test.swift": 1000]
let defaultValue: Int = 2000 //本地读取
let _ = cache["hello.swift"] ??? defaultValue
let _ = cache["hello.swift"] != nil ? cache["hello.swift"] : defaultValue


infix operator ??
func ??<T>(optional:T?, defaultValue:() -> T) -> T {
    
    if let x = optional {
        
        return x
        
    } else {
        
        return defaultValue()
    }
}


/// Swift标准库中的 ?? 运算符 使用定义
infix operator ????
func ???<T>(optional: T?, defaultValue:@autoclosure() throws -> T) rethrows -> T {
    
    if let x = optional {
        
        return x
        
    } else {
        
        return try defaultValue()
        
    }
}



/// EXAMPLE - 可选链

/// 订单
struct Order {
    let orderNumber: Int
    let person: Person?
}


struct Person {
    let name: String
    let address: Address?
}

/// 地址
struct Address{
    let streetName: String
    let city: String
    let state: String?
}


let order = Order(orderNumber: 40, person: nil)

let _ = order.person?.address?.state




switch madridPopulation {
    
case 0? : print("Nobody in Madrid")
case(1..<1000)? :print("Less than a million in Madrid")
case let x? : print("\(x) people in Madrid")
case nil : print("We don't know about Madrid")
    
}


func populationDescription(for city:String) -> String? {
    
    guard let population = cities[city] else {
        
        return nil
    }
    
    return "The population of Madrid is \(population)"
}

populationDescription(for: "Madrid")


///MARK: 可选映射

func increment(optional: Int?) -> Int? {
    
    guard let x = optional else { return nil }
    
    return x + 1
}


extension Optional {
    
    func map<U>(_ transform:(Wrapped) -> U) -> U? {
        
        guard let x = self else { return nil }
        
        return transform(x)
    }
}

/// 使用Map改写
func increment1(optional: Int?) -> Int? {
    
    return optional.map{ $0 + 1 }
}


func add(_ optionalX:Int?, _ optionalY: Int?) -> Int? {
    
    guard let x = optionalX, let y = optionalY else {
        
        return nil
    }
    
    return x + y
}


// 下面语句会报错，不予承认
//let x:Int ？ = 3
//let y:Int ? = nil
//let z:Int ? = x + y

//
let capitals = [
    "France":"Paris",
    "Spain":"Madrid",
    "The Netherlands":"Amsterdam",
    "Belgium":"Brussels"
]


func populationOfCapital(country:String) -> Int? {
    
    guard let capital = capitals[country], let population = cities[capital] else {
        return nil
    }
    
    return population * 1000
}

extension Optional {
    
    func flatMap<U>(_ transform:(Wrapped) -> U?) -> U? {
        
        guard let x = self else { return nil }
        
        return transform(x)
    }
}


/// 改写add
func add4(_ optionalX:Int?, _ optionalY: Int?) -> Int? {
    
    return optionalX.flatMap{ x in
        
        optionalY.flatMap{ y in
            
            return x + y
        }
    }
}


func populationOfCaptital2(country:String) -> Int? {
    
    return capitals[country].flatMap{
        
        cities[$0].flatMap{
            
            return $0 * 1000
        }
    }
}


/// 通过链式重写上述嵌套写法
func populationOfCaptital3(country:String) -> Int? {
    
    return capitals[country].flatMap{captical in cities[captical]}.flatMap{ population in population * 1000 }
    
    //或者更简洁
//    return capitals[country].flatMap{ cities[$0] }.flatMap{ $0 * 1000 }
}

//可选值有助于捕捉难以察觉的细微错误，其中一些错误很容易在开发过程中被发现.
//坚持使用可选值能够从根本上杜绝这类错误





