//
//  RJUivew+LayoutMethod.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/10.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
/// 屏幕尺寸
 let kScreenW = CGFloat(UIScreen.main.bounds.width)
 let kScreenH = CGFloat(UIScreen.main.bounds.height)



let kDevice_Is_iPhone4s    = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 640, height: 960), (UIScreen.main.currentMode?.size)!) : false
let kDevice_Is_iPhone5     = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 640, height: 1136), (UIScreen.main.currentMode?.size)!) : false
let kDevice_Is_iPhone6     = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 750, height: 1334), (UIScreen.main.currentMode?.size)!) : false
let kDevice_Is_iPhone6Plus = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1242, height: 2208), (UIScreen.main.currentMode?.size)!) : false
let kDevice_Is_iPhoneX     = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1125, height: 2436), (UIScreen.main.currentMode?.size)!) : false



/// 纯代码适配等比例拉伸(以iPhone6为标准)
let kSCREEN_WIDTH_RATIO  = kScreenW / 375.0
let kSCREEN_HEIGHT_RATIO = kDevice_Is_iPhoneX ? (kScreenH - 78)/667.0 : (kScreenH < 500 ? 1 : kScreenH / 667.0) //5/5s一下不做适配
/// 自动适配宽度
///
/// - Parameter width: 基础宽度 以iPhone6为基础
/// - Returns: 适配后的宽度
func kAutoWid(_ width:CGFloat) -> CGFloat {
    return width * kSCREEN_WIDTH_RATIO
}

/// 自动适配高度
///
/// - Parameter height: 基础高度 以iPhone6为基础
/// - Returns: 适配后的高度
func kAutoHei(_ height:CGFloat) -> CGFloat {
    return height * kSCREEN_HEIGHT_RATIO
}
extension UIView{
    /// x坐标
     var x : CGFloat{
        get{
            return frame.origin.x
        }
        set(x){
            frame.origin = CGPoint(x: x, y: frame.origin.y)
        }
    }
    
    /// Y坐标
     var y : CGFloat{
        get{
            return frame.origin.y
        }
        set(y){
            frame.origin = CGPoint(x: frame.origin.x, y: y)
        }
    }
    
    /// 宽
     var width : CGFloat{
        get{
            return frame.size.width
        }
        set(width){
            frame.size = CGSize(width: width, height: frame.size.height)
        }
    }
    
    /// 高
     var height : CGFloat{
        get{
            return frame.size.height
        }
        set(height){
            frame.size = CGSize(width: frame.size.width, height: height)
        }
    }
    
    /// 尺寸
     var size   : CGSize {
        get{
            return frame.size
        }
        set(size){
            frame.size = size
        }
    }
    
    /// 坐标
     var origin   : CGPoint {
        get{
            return frame.origin
        }
        set(origin){
            frame.origin = origin
        }
    }
   
    /// 中心点 X坐标
     var centerX   : CGFloat {
        get{
            return self.center.x
        }
        set(centerX){
            self.center.x = centerX
        }
    }
    
    /// 中心点 Y坐标
     var centerY   : CGFloat {
        get{
            return self.center.y
        }
        set(centerY){
            self.center.y = centerY
            
        }
        
    }
}

