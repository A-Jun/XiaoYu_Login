//
//  RJPersonInformationModel.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/23.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit

class RJPersonInformationModel: NSObject {
    static let sharePerson = RJPersonInformationModel()
    /// 用户ID
    var ID    : Int?
    /// 左右手 布尔类型 默认为 true 右手
    var hander : Bool = true
    /// 性别   布尔类型 默认为 true 男
    var gender : Bool = true {
        willSet{
            height = newValue ? 170 : 160
            weight = newValue ?  70 :  50
        }
    }
    /// 身高 单位cm
    var height : Int = 170
    /// 体重 单位Kg
    var weight : Int = 70
    var name   : String? = "UserName"
    var icon   : UIImage? = UIImage.currentBoudle("login_default_avatar", RJPersonInformationModel.self)

}
