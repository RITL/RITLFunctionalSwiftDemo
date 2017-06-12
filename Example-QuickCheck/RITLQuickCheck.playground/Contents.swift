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
}


let _ = String.arbitrary()



///MARK: 实现check方法

func check1<A:Arbitrary>(_ message:String,_ property:(A) -> Bool) -> () {
    
    let numberOfIterations = message.characters.count
    
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
}

check1("Area should be at least 0"){ (size: CGSize) in size.area >= 0 }

//缩小范围
check1("Every string starts with Hello"){ (s: String) in
    s.hasPrefix("Hello")
}


extension Int: Smaller {
    
    func smaller() -> Int? {
        
        return self == 0 ? nil : self / 2
    }
}

let _ = 100.smaller() //50


//对于字符串，移除第一个字符(除非该字符串为空)

extension String: Smaller {
    
    func smaller() -> String? {
        
        return isEmpty ? nil : String(characters.dropFirst())
    }
}


// 使用函数式的风格优化上述写法,使用map或者reduce替代for








