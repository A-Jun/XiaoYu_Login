//
//  RJUIView+FunctionMethod.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/10.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit

public extension UIView{
    /// 圆角裁剪
    ///
    /// - Parameters:
    ///   - radius: 角度
    ///   - borderWidth:边界宽度
    ///   - borderColor: 边界颜色
    public func cornerCutWith(_ radius:CGFloat, _ borderWidth:CGFloat = 0.1, _ borderColor:UIColor = .clear) -> Void {
        
        let  lineWidth = 2 * borderWidth
        let cutLayer = CAShapeLayer()
        cutLayer.frame       = self.bounds
        cutLayer.strokeColor = borderColor.cgColor
        cutLayer.fillColor   = UIColor.clear.cgColor
        cutLayer.lineWidth   = lineWidth
        cutLayer.path        = cornerPath(radius)
        layer.addSublayer(cutLayer)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame       = self.bounds
        maskLayer.path        = cornerPath(radius - lineWidth)
        layer.mask            = maskLayer
    }
    
    /// 圆角路径
    ///
    /// - Parameter radius: 圆角半径
    /// - Returns: 路线
    private
    func cornerPath(_ radius:CGFloat) -> CGPath {
        let path = UIBezierPath()
        
        let leftBotPoint = CGPoint(x: radius, y: self.height - radius)
        path.addArc(withCenter: leftBotPoint, radius: radius, startAngle: .pi / 2.0, endAngle: .pi, clockwise: true)
        
        let leftTopPoint = CGPoint(x: radius, y: radius)
        path.addArc(withCenter: leftTopPoint, radius: radius, startAngle: .pi, endAngle: -.pi / 2.0, clockwise: true)
        
        path.addLine(to: CGPoint(x: self.width - radius, y: 0))
        
        let rightTopPoint = CGPoint(x: self.width - radius, y: radius)
        path.addArc(withCenter: rightTopPoint, radius: radius, startAngle: -.pi/2.0, endAngle: 0, clockwise: true)
        
        let rightBotPoint = CGPoint(x: self.width - radius, y: self.height - radius)
        path.addArc(withCenter: rightBotPoint, radius: radius, startAngle: 0, endAngle: .pi/2.0, clockwise: true)
        
        path.addLine(to: CGPoint(x: radius, y: self.height))
        
        return path.cgPath
    }
}
