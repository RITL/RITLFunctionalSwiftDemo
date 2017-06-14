//: Playground - noun: a place where people can play
//: Playground - 可变性与不可变性


import UIKit

let x = 3 //不可变
var y = 3 //可变

//x = 4 //报错
y = 4



///MARK: 值类型与引用类型

// 值类型
struct PointStruct {
    var x: Int
    var y: Int
}

//
var structPoint = PointStruct(x: 1, y: 2)
var sameStructPoint = structPoint
sameStructPoint.x = 3 //只修改sameStructPoint属性值，structPoint不变
structPoint
sameStructPoint

// 引用类型 Class
class PointClass {
    
    var x: Int
    var y: Int
    
    init(x: Int,y: Int) {
        self.x = x
        self.y = y
    }
}

var classPoint = PointClass(x: 1, y: 2)
var sameClassPoint = classPoint
sameClassPoint.x = 3 //sameClassPoint与classPoint属性值都发生了变化
classPoint
sameClassPoint


/// 结构体返回原点
func setStructToOrigin(point: PointStruct) -> PointStruct {
    
    var newPoint = point
    newPoint.x = 0
    newPoint.y = 0
    return newPoint
}

var structOrigin = setStructToOrigin(point: structPoint)


/// 使用类
func setClassToOrigin(point: PointClass) -> PointClass {
    
    point.x = 0
    point.y = 0
    return point
}

var classOrigin = setClassToOrigin(point: classPoint)


///为struct提供mutabling方法，只作用于单一变量，不影响替他变量

extension PointStruct {
    mutating func setStructToOrigin(){
        x = 0
        y = 0
    }
}

var myPoint = PointStruct(x: 100, y: 100)
let otherPoint = myPoint
myPoint.setStructToOrigin()
otherPoint
myPoint


/// 结构体与类: 究竟是否可变

//对pointStruct以不可变方式进行实例化
let immutablePoint = PointStruct(x: 0, y: 0)

//immutablePoint = PointStruct(x: 1, y: 2)//被拒绝
//immutablePoint.x = 3 //被拒绝

//可变
var mutablePoint = PointStruct(x: 0, y: 0)
mutablePoint.x = 3 //木毛病..


struct ImmutablePointStruct {
    let x: Int
    let y: Int
}

var immutablePoint2 = ImmutablePointStruct(x: 1, y: 1)
//immutablePoint2.x = 3 //被拒接

//但是可以赋新值
immutablePoint2 = ImmutablePointStruct(x: 3, y: 3)


//Swift数组
//写入时复制 copy-on-write



/// 模拟
func sum(integter:[Int]) -> Int {
    
    var result = 0
    for x in integter {
        
        result += x
    }
    return result
}
