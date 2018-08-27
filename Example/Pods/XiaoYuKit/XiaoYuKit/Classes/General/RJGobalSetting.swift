//
//  RJGobalSetting.swift
//  swiftTest
//
//  Created by RJ on 2018/7/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

import UIKit

//字体适配

public func RJFontMedium(_ size:CGFloat) -> UIFont {
    return UIFont.init(name: "PingFang-SC-Medium", size: CGFloat(size))!
}
public func RJFontHeavy(_ size:CGFloat) -> UIFont {
    return UIFont.init(name: "PingFang-SC-Heavy", size: CGFloat(size))!
}
public func RJFontBold(_ size:CGFloat) -> UIFont {
    return UIFont.init(name: "PingFang-SC-Semibold", size: CGFloat(size))!
}

public enum OemType :String {
    case Orignal     // 酷浪小羽
    case NoBinding   // 没绑定
    case XiaoYu      // 小羽
    case Taan        // 泰昂
    case Sotx        // 索牌
    case M6881       // 自家的品牌
    case CQ          // 川崎
    case HD          // 海德
    case HDNew       // 海德2s
    case AB          // 艾宝
    case Unknown7
    case Unknown8
    case Unknown9
    case TestXiaoYu  // 测试小羽
    case XiaoYu2S    // 小羽2S
    case HS           // 何氏
    case NG           // 印尼
    case NF           // 印尼
    case NH           // 打球吧
    case NI           // 来动
    case NJ           // 马来西亚
    case CL_3_0_0     // 酷浪小羽3.0 外挂式
    case CL_3_0_1     // 酷浪小羽3.0 后盖式
    case HD_3_0_0     // 海德3.0
    
    case OL_2         // 奥利佛
    case OL2s         // 奥利佛2s
    
}



