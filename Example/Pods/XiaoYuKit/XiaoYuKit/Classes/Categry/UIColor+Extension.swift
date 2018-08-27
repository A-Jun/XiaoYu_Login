//
//  RJUIColor+Extension.swift
//  swiftTest
//
//  Created by RJ on 2018/7/18.
//  Copyright © 2018年 RJ. All rights reserved.
//

import UIKit

public extension UIColor{
    convenience public init(_ hexColor:NSInteger , _ alpha:CGFloat){
        let red   = CGFloat((hexColor & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexColor & 0xFF00) >> 8) / 255.0
        let blue  = CGFloat((hexColor & 0xFF) ) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    convenience public init(_ hexColor:NSInteger){
        self.init(hexColor, 1)
    }
}
