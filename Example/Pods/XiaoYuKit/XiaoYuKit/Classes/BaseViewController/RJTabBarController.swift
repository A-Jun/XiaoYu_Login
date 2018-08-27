//
//  RJTabBarController.swift
//  swiftTest
//
//  Created by RJ on 2018/7/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

import UIKit

public class RJTabBarController: UITabBarController {

    override open func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    open func creatItemsWith(_ viewControllers:[String], _ titles :[String],_ images:[String],_ selectImages:[String]) -> Void {
        
        for index in 0..<viewControllers.count {
//            获取命名空间
            let namespace      = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            let array          = namespace.components(separatedBy: ".")
            var newNameSpace   = ""
            
            for row in 0 ..< array.count {
                newNameSpace += array[row]
                if row + 1 == array.count {  break }
                newNameSpace += "_"
            }
            let clsName = newNameSpace  + ".RJ" + viewControllers[index] + "ViewController"
            let vcClass = NSClassFromString(clsName) as! RJBaseViewController.Type
            let vc      = vcClass.init()
            let image   = UIImage(named: images[index])?.withRenderingMode(.alwaysOriginal)
            let selectedImage = UIImage(named: selectImages[index])?.withRenderingMode(.alwaysOriginal)

            let item      = UITabBarItem(title: titles[index], image:image , selectedImage:selectedImage )
            vc.tabBarItem = item
            let nav       = RJNavigationController(rootViewController: vc)
            addChildViewController(nav);
        }
        
        
    }

}
