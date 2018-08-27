//
//  RJButton.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/23.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
enum RJButtonTagName:String {
    case leftHand
    case rightHand
    case male
    case female
}
class RJButton: UIButton {
    var tagName :RJButtonTagName = .leftHand
}
