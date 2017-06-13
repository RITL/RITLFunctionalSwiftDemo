//: Playground - noun: a place where people can play
//: Playground - QuickCheck - 单元测试(XCTest)

import UIKit


print(112)

//example 测试 x + y = y + x

func check(_ reason:String,_ result:Bool) {
    
    if result {
        print("\(reason)")
    }
}


func check(_ reason:String, value:Int = 0, _ handler:(Int) -> Bool) {
    
    if handler(value) {
        print("\(reason)")
    }
}


func pluslsCommutative(x:Int = 0,y:Int = 0) -> Bool {
    return x + y == y + x
}

//
check("Plus should be commutative", pluslsCommutative())

//减法测试
func minuslsCommutative(x:Int = 0,y:Int = 0) -> Bool {
    return x - y == y - x
}

check("Minus should be commutative", minuslsCommutative())


//使用Swift的尾随闭包语法
check("Additive identity"){ (x: Int) in
    
    x + 0 == x
}



///MARK: 开始构建QuickCheck
protocol Smaller {
    func smaller() -> Self?
}

//构建生成随机数
protocol Arbitrary : Smaller {
    
    static func arbitrary() -> Self
}


extension Int : Arbitrary {
    
    static func arbitrary() -> Int {
        return Int(arc4random())
    }
    
    func smaller() -> Int? {
        
        return self == 0 ? nil : self / 2
    }
}




let arcRandom = Int.arbitrary()


/// 为了防止随机整数越界，添加变量对其进行约束
extension Int {
    
    static func arbitrary(in range:CountableRange<Int>) -> Int {
        
        let diff = range.upperBound - range.lowerBound
        
        return range.lowerBound + (Int.arbitrary() % diff)
    }
}

///生成随机字符
extension UnicodeScalar : Arbitrary {
    
    static func arbitrary() -> UnicodeScalar {
        
        return UnicodeScalar(Int.arbitrary(in: 65..<90))!
    }
    
    func smaller() -> UnicodeScalar? {
        
        return self
    }
}


///生成随机字符串
extension String : Arbitrary {
    
    static func arbitrary() -> String {
        
        let randomLength = Int.arbitrary(in: 0..<40)//长度在0 - 39
        let randomScalars = (0..<randomLength).map{_ in //进行循环随机字符
            
            UnicodeScalar.arbitrary()
        }
        
        return String(UnicodeScalarView(randomScalars))//拼接字符串
    }
    
    func smaller() -> String? {
        
        return isEmpty ? nil : String(characters.dropFirst())
    }
}


let _ = String.arbitrary()



///MARK: 实现check方法

let numberOfIterations = 10

func check1<A:Arbitrary>(_ message:String,_ property:(A) -> Bool) -> () {
    
    for _ in 0..<numberOfIterations {
        
        let value = A.arbitrary()
        guard property(value) else {
            
            print("\"\(message)\" doesn't hold:\(value)"); return
        }
    }
    print("\"\(message)\" passed \(numberOfIterations) tests.")
}



//测试上述方法
extension CGSize {
    
    var area : CGFloat {
        return width * height
    }
}



extension CGSize : Arbitrary {
    
    static func arbitrary() -> CGSize {
        
        return CGSize(width: .arbitrary(), height: .arbitrary())
    }
    
    
    func smaller() -> CGSize? {//无用
        
        return self
    }
}



check1("Area should be at least 0"){ (size: CGSize) in size.area >= 0 }


check1("Every string starts with Hello"){ (s: String) in
    s.hasPrefix("Hello")
}

///MARK: 缩小范围引用Smaller - 对于整数，尝试除以二，直到等于0



let _ = 100.smaller() //50



///MARK: 反复缩小范围


/// 通过反复缩小测试中发现的范例所属的范围
func iterate<A>(while condition:(A) -> Bool, initial: A, next:(A) -> A?) -> A {
    
    guard let x = next(initial),condition(x) else {// 没有操作返回初始值
        
        return initial
    }
    
    return iterate(while: condition, initial: x, next: next)
    
}


/// 随机整数
func check2<A:Arbitrary>(_ message:String, _ property:(A) -> Bool) -> () {
    
    for _ in 0..<numberOfIterations {
        
        let value = A.arbitrary()
        guard property(value) else {
            
            let smallerValue = iterate(while:{ !property( $0 ) },initial:value){ $0.smaller() }
            
            print("\"\(message)\" dosen't hold:\(smallerValue)"); return
        }
    }
    
    print("\"\(message)\" passed \(numberOfIterations) tests.")
}


/// 随机数组

/// 函数式的快速排序
func qsqrt(_ input:[Int]) -> [Int]
{
    var array = input
    if array.isEmpty { return [] }//空判断
    
    let pivot = array.removeFirst() //第一个元素，并且移除
    let lesser = array.filter{ $0 < pivot } // 获得所有比第一个元素小的数组
    let greater = array.filter{ $0 >= pivot } // 获得所有大于等于第一个元素的数组
    let intermediate = qsqrt(lesser) + [pivot] // 对小于的元素进行快排并添加最大的元素
    
    return intermediate + qsqrt(greater) //同理
}



extension Array : Smaller {
    
    func smaller() -> Array<Element>? {
        
        guard !isEmpty else { return nil }
        return Array(dropLast())
    }
}



extension Array where Element: Arbitrary {
    
    static func arbitrary() -> [Element] {
        
        let randomLength = Int.arbitrary(in: 0..<50)
        return (0..<randomLength).map{ _ in .arbitrary() }
    }
}


///检测当前快排
//check2("qsort should behave like sort"){ (x:[Int]) in
//    
//    return qsqrt(x) == x.sorted()
//}



