//
//  LoginLocation.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/9.
//  Copyright © 2018年 coollang. All rights reserved.
//

import Foundation

/// 登录界面本地化
func LoginLocation(_ key:String) -> String {
    return Bundle.localizedString(forKey: key, value: "", table: "login", targetClass: RJLoginHelper.self)
}

