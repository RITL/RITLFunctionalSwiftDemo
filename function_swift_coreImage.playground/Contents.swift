//: Playground - noun: a place where people can play
//: Playground - 模拟在真实开发中如何使用函数响应式 - 封装CoreImage库

import UIKit
import CoreImage

typealias Filter = (CIImage) -> CIImage

//基本形态
//func myFilter(...) -> Filter

/// 高斯模糊滤镜
func blur(radius: Double) -> Filter {
    
    return { image in
        
        // 初始化参数
        let paramters: [String:Any] = [
            kCIInputRadiusKey : radius, // 模糊
            kCIInputImageKey : image    // 输入的image(CIImage)
        ]
        
        // 初始化过滤器
        guard let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: paramters) else {  fatalError("") }
        
        //输出图片
        guard let outputImage = filter.outputImage else {  fatalError("") }
        
        return outputImage
    }
}



//MARK: 颜色生成滤镜

/// 固定颜色的滤镜
func generate(color: UIColor) -> Filter {
    
    return { _ in
        
        
        let paramters : [String:Any] = [
            kCIInputColorKey: CIColor(cgColor: color.cgColor) //颜色
        ]//初始化参数
        
        guard let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: paramters) else { fatalError()  }
        
        guard let outputImage = filter.outputImage else { fatalError() }
        
        return outputImage
    }
}



/// 合成滤镜
func compositeSourceOver(overlay: CIImage) -> Filter {
    
    return { image in
        
        let patamters = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
        ]
        
        guard let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: patamters) else { fatalError("1") }
        guard let outputImage = filter.outputImage else {  fatalError("2") }
        
        return outputImage.cropping(to: image.extent)
    }
}


/// 颜色叠层滤镜
func overlay(color: UIColor) -> Filter{
    
    return { image in
        
        // 获得固定颜色的滤镜
        let overlay = generate(color: color)(image).cropping(to: image.extent)
        
        // 合成
        return compositeSourceOver(overlay: overlay)(image)
    }
}


let url = URL(string: "http://www.objc.io/images/covers/16.jpg")
let image = CIImage(contentsOf: url!)

//设置滤镜
let radius = 5.0
let color = UIColor.red.withAlphaComponent(0.2)


let blurredImage = blur(radius: radius)(image!)

//let overlaidImage = overlay(color: color)(blurredImage)

/**  放开上面语句会报错，打印如下: 听说是环境问题..Playground --- how to do? **/

//Jun  8 13:54:43  function_swift_coreImage[2624] <Error>: CGContextSaveGState: invalid context 0x0. If you want to see the backtrace, please set CG_CONTEXT_SHOW_BACKTRACE environmental variable.
//Jun  8 13:54:43  function_swift_coreImage[2624] <Error>: CGContextSetBlendMode: invalid context 0x0. If you want to see the backtrace, please set CG_CONTEXT_SHOW_BACKTRACE environmental variable.
//Jun  8 13:54:43  function_swift_coreImage[2624] <Error>: CGContextSetAlpha: invalid context 0x0. If you want to see the backtrace, please set CG_CONTEXT_SHOW_BACKTRACE environmental variable.
//Jun  8 13:54:43  function_swift_coreImage[2624] <Error>: CGContextTranslateCTM: invalid context 0x0. If you want to see the backtrace, please set CG_CONTEXT_SHOW_BACKTRACE environmental variable.
//Jun  8 13:54:43  function_swift_coreImage[2624] <Error>: CGContextScaleCTM: invalid context 0x0. If you want to see the backtrace, please set CG_CONTEXT_SHOW_BACKTRACE environmental variable.
//Jun  8 13:54:43  function_swift_coreImage[2624] <Error>: CGContextDrawImage: invalid context 0x0. If you want to see the backtrace, please set CG_CONTEXT_SHOW_BACKTRACE environmental variable.
//Jun  8 13:54:43  function_swift_coreImage[2624] <Error>: CGContextRestoreGState: invalid context 0x0. If you want to see the backtrace, please set CG_CONTEXT_SHOW_BACKTRACE environmental variable.




//MARK:  复合函数，减少括号错综复杂问题

func compose(filter filter1:@escaping Filter, with filter2: @escaping Filter) -> Filter{
    
    return { image in filter2( filter1(image) ) }
    
}


// 优化后的方法
let blurAndOverlay = compose(filter: blur(radius: radius), with: overlay(color: color))
let result1 = blurAndOverlay(image!)

//MARK: 自定义运算符
//infix operation>>>

prefix func >>>(filter1: @escaping Filter,filter2: @escaping Filter) -> Filter {
    
    return { image in filter2( filter1(image) ) }
}

let blurAndOverlay2 = blur(radius: radius) >>> overlay(color: color)
let result2 = blurAndOverlay2(image)



//MARK: 柯里化

func add1(_ x:Int, _ y:Int) -> Int {
    
    return x + y
}


func add2(_ x:Int) -> ((Int)-> Int){ //为add1的柯里化
    
    return { (y) in  x + y }
}


func add3(_ x:Int) -> (Int) -> Int {
    
    return { (y) in x+ y }
}


let add1Result = add1(1, 2) // 3
let add2Result = add2(1)(2) // 3
let add3Result = add3(1)(2) // 3
