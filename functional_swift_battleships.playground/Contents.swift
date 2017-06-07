//: Playground - noun: a place where people can play
//: Playground - 模拟最简单的函数响应式

import UIKit

typealias Distance = Double

/// 位置
struct Postion {
    var x: Double
    var y: Double
}


extension Postion{
    
    /// 是否进入攻击范围
    ///
    /// - Parameter range: 攻击范围
    /// - Returns: 是否进入攻击范围
    func within(range: Distance) -> Bool {
        
        return sqrt(x * x + y * y) <= range
    }
}


/// 船
struct Ship {
    var postion: Postion //当前位置
    var firingRange: Distance //攻击范围
    var unsafeRange: Distance //不安全范围，在此范围内不进行攻击
}


extension Ship {
    
    /// 是否有另一艘船位于攻击范围之内
    ///
    /// - Parameter target: 目标船只
    /// - Returns: 是否有另一艘船位于攻击范围之内
    func canEngage(ship target: Ship) -> Bool {
        
        let dx = target.postion.x - postion.x
        let dy = target.postion.y - postion.y
        let targetDistance = sqrt(dx * dx + dy * dy)//距离
        
        return targetDistance <= firingRange
    }
    
    
    /// 是否由另一搜船位于攻击范围之内（需要在安全范围内）
    ///
    /// - Parameter target: 目标船只
    /// - Returns:
    func canSafelyEngage(ship target: Ship) -> Bool {
        
        let dx = target.postion.x - postion.x
        let dy = target.postion.y - postion.y
        let targetDisctance = sqrt(dx * dx + dy * dy)
        
        return targetDisctance <= firingRange && targetDisctance > unsafeRange
    }
}


extension Ship {
    
    /// 避免敌方过于接近友方船只
    ///
    /// - Parameters:
    ///   - target: 目标船只
    ///   - friendly: 友军
    /// - Returns:
//    func canSafelyEngage(ship target: Ship, friendly: Ship) -> Bool {
//
//        // 自己距离敌军的距离
//        let dx = target.postion.x - postion.x
//        let dy = target.postion.y - postion.y
//        let targetDistance = sqrt(dx * dx + dy * dy)
//
//        // 友军距离敌军的距离
//        let friendlyDx = friendly.postion.x - target.postion.x
//        let friendlyDy = friendly.postion.y - target.postion.y
//        let friendlyDistance = sqrt(friendlyDx * friendlyDx + friendlyDy * friendlyDy)
//
//         return targetDistance <= firingRange
//            && targetDistance > unsafeRange
//            && friendlyDistance > unsafeRange //要小于安全距离，不然会影响友军
//    }
}



//MARK:  初步开始优化

extension Postion {
    
    /// 距离p模拟的Postion对象
    func minus(_ p: Postion) -> Postion {
        
        return Postion(x: x - p.x, y: y - p.y)
    }
    
    /// 计算距离
    var length: Double {
        
        return sqrt(x * x + y * y)
    }
}


extension Ship {
    
    /// 普通优化canSafelyEngage方法
    func canSafelyEngage2(ship target: Ship, friendly: Ship) -> Bool {
        
        let targetDistance = target.postion.minus(postion).length
        let friendDistance = target.postion.minus(friendly.postion).length
        
        return targetDistance <= firingRange
            && targetDistance > unsafeRange
            && friendDistance > unsafeRange //要小于安全距离，不然会影响友军
    }
}






///MARK: 一等函数开始，在Swift中函数是一等值

typealias Region = (Postion) -> Bool


///定义一个区域以原点为圆心的圆
func circle(radius: Distance) -> Region {
    
    return { point in point.length <= radius}
}


/// 定义一个区域以center为圆心的圆
func circle2(radius: Distance,center: Postion) -> Region {
    
    return { point in point.minus(center).length <= radius}
}


///MARK: 区域变换函数
func shift(_ region: @escaping Region,by offset: Postion) -> Region {
    
    return { point in region(point.minus(offset)) }
}


/// 创建一个圆心为(5，5),半径为10的圆
let shifted = shift(circle(radius: 10), by: Postion(x: 5,y: 5))



/// 通过反转一个区域以定义另一个区域，新产生的区域由原区域以外的所有点组成
func invert(_ region: @escaping Region) -> Region {
    
    return { point in !region(point) }
}

/// 计算交集
func intersect(_ region: @escaping Region,with other:@escaping Region) -> Region {
    
    return { point in region(point) && other(point) }
}

/// 计算并集
func union(_ region: @escaping Region,with other:@escaping Region) -> Region {
    
    return { point in region(point) || other(point) }
}

/// 所有的在第一个区域中且不在第二个区域中的点构建一个新的区域
func subtract(_ region: @escaping Region, from original:@escaping Region) -> Region {
    
    return intersect(original, with: invert(region))
}


///MRAK: 函数响应式开始

extension Ship {
    
    /// 使用函数响应式优化的canSafelyEngage - 与 74:出现命名冲突
    func canSafelyEngage(ship target: Ship, friendly: Ship) -> Bool {
        
        //攻击达到的所有区域
        let rangeRegion = subtract(circle(radius: unsafeRange), from: circle(radius: firingRange))
        
        //获得偏移后的区域
        let firingRegion = shift(rangeRegion, by: postion)
        
        //获得影响友军的区域
        let friendlyRegion = shift(circle(radius: unsafeRange), by: friendly.postion)
        
        //获得差集
        let resultRegion = subtract(firingRegion, from: friendlyRegion)
        
        //当前目标位置是否存在攻击区域内
        return resultRegion(target.postion)
    }
}


//更好的解决方案，可通过extension进行拓展
//struct Region {
//
//    let lookup: (Postion) -> Bool
//}

