//
//  RJProgressHUD.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/24.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit

//MARK: - 文字提示
public class RJProgressHUD: UIView {
    public var margin = 20.0
    
    public class func showMessage(_ message:String?, in view:UIView?) -> Void {
        guard let superView = (view ?? UIApplication.shared.keyWindow)  else { return  }
        let hud = RJProgressHUD()
        hud.backgroundColor = .black
        
        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        
        
        let width = label.frame.size.width + CGFloat(2.0*hud.margin)
        let height = label.frame.size.height * 2.0
        hud.size = CGSize(width: width, height: height)
        label.center   = CGPoint(x: width / 2.0, y: height / 2.0)
        hud.addSubview(label)
        
        
        let x = (superView.bounds.width) / 2.0
        let y = (superView.bounds.height) / 2.0
        hud.center = CGPoint(x: x, y: y)
        superView.addSubview(hud)
        
        hud.cornerCutWith(8)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            hud.removeFromSuperview()
        }
    }
}
