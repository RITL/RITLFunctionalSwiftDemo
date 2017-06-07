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
            kCIInputRadiusKey : radius, // 圆角弧度
            kCIInputImageKey : image    // 输入的image(CIImage)
        ]
        
        // 初始化过滤器
        guard let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: paramters) else {  fatalError() }
        
        //输出图片
        guard let outputImage = filter.outputImage else {  fatalError() }
        
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
        
        guard let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: paramters) else {  fatalError()  }
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
        
        guard let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: patamters) else { fatalError() }
        guard let outputImage = filter.outputImage else {  fatalError() }
        
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


print(123)


let filterNames = CIFilter().inputKeys

print("\(filterNames)")

