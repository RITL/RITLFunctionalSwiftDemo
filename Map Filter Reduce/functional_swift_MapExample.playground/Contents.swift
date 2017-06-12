//: Playground - noun: a place where people can play
//: Playground - 高阶函数 - Map、Filter、Reduce实际应用

import UIKit

//定义由城市的名字和人口(单位为千居民)组成

struct City {
    let name: String      // 名字
    let population: Int   // 人口
}

//example
let paris = City(name: "Paris", population: 2241)
let madrid = City(name: "Madrid", population: 3165)    //马德里
let amsterdam = City(name: "Amsterdam", population: 827)
let berlin = City(name: "Berlin", population: 3562)    //柏林


let cities = [paris,madrid,amsterdam,berlin]


extension City {
    
    /// 1000 000 进行比例缩放的City -> population * 1000
    func scalingPopulation() -> City {
        
        return City(name: name, population: population * 1000)
    }
}


///MARK: 筛选出居民数量至少100w的城市，打印一份城市的名字以及总人数的列表

cities.filter{ $0.population > 1000}                //选出人数大于1000 000的城市
    .map{ $0.scalingPopulation() }                  //每个城市的人数 进行 city对象
    .reduce("City:Population") { (result, city)  in //进行整体打印
    return result + "\n" + "\(city.name):\(city.population)"
}


//复杂写法
cities.filter { (city) -> Bool in
    
        return city.population > 1000
    
    }.map { (city) -> City in
        
        return city.scalingPopulation()
        
    }.reduce("City:Population") { (result, city) -> String in
        
        return result + "\n" + "\(city.name):\(city.population)"
}




///MARK: Any

///返回参数，什么也不做

/// 使用泛型的返回参数
func noOp<T>(_ x:T) -> T{
    
    return x
}

/// 使用Any的返回参数
func noOpAny(_ x:Any) -> Any {
    
    return x
}


func noOpAnyWrong(_ x:Any) -> Any {
    
    return 0
}


