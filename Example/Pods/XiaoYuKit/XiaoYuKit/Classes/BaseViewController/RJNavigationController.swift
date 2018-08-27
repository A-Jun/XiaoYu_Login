//
//  RJNavigationController.swift
//  swiftTest
//
//  Created by RJ on 2018/7/16.
//  Copyright © 2018年 RJ. All rights reserved.
//

import UIKit
let navBarTinColor    = UIColor(0x04191e)

open class RJNavigationController: UINavigationController {

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = navBarTinColor
    }

}
