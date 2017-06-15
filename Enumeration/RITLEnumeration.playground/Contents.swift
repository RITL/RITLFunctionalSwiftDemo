//: Playground - noun: a place where people can play
//: Playground - 枚举

import UIKit

/// 模拟一个编码枚举类型
enum Encoding {
    
    case ascii
    case nextstep
    case japaneseEUC
    case utf8
    
}

extension Encoding {
    
    /// 对编码类型进行映射
    var nsStringEncoding:String.Encoding {
        switch self {
        case .ascii: return String.Encoding.ascii
        case .nextstep: return String.Encoding.nextstep
        case .japaneseEUC: return String.Encoding.japaneseEUC
        case .utf8: return String.Encoding.utf8
        }
    }
}


extension Encoding {
    
    /// 构造函数
    init?(encoding: String.Encoding) {
        
        switch encoding {
        case String.Encoding.ascii: self = .ascii
        case String.Encoding.nextstep: self = .nextstep
        case String.Encoding.japaneseEUC: self = .japaneseEUC
        case String.Encoding.utf8: self = .utf8
        default: return nil
        }
    }
}


//如上所写，外界不在需要编写Switch方法
extension Encoding {
    
    var localizedName: String {
        return String.localizedName(of: nsStringEncoding)
    }
}



// 重写之前的populationOfCapital函数:

/* 原型 */

