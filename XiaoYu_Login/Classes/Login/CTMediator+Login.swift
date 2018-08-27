//
//  RJdasd.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/17.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
import CTMediator
public enum LoginAction : String {
    case ViewController
}
public var defaultParams :[AnyHashable :Any] = ["defaultKey":"defaultValue",
                                                kCTMediatorParamsKeySwiftTargetModuleName:"XiaoYu_Login"]
public extension CTMediator {
    
    public class func loginHomeViewController() -> UINavigationController {
        return  CTMediator.sharedInstance().performTarget("Login", action: "ViewController", params: defaultParams, shouldCacheTarget: true) as! UINavigationController
    }
}


