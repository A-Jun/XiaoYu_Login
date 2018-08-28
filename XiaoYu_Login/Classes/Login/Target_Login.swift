//
//  Target_Login.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/11.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
//类用@objc()修饰
//方法用@objc修饰
@objc
class Target_Login: NSObject {
    
    @objc
    func Action_ViewController(_ params:[AnyHashable :Any]) -> UINavigationController {
        return RJNavigationController(rootViewController: RJLoginHomeViewController())
    }
}
