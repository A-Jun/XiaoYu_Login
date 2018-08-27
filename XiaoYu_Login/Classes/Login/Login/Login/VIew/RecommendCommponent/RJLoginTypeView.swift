//
//  RJLoginTypeView.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/13.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit

class RJLoginTypeView: UIView {
    private
    let tap = UITapGestureRecognizer()
    private
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private
    lazy var name: UILabel = {
        let lable = UILabel()
        lable.textColor = grayTextColor
        lable.font      = RJFontMedium(18)
        return lable
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience
    init(image:UIImage?, title:String? ,target:Any, sel:Selector) {
        self.init(frame: .zero)
        configureUI()
        icon.image = image
        name.text  = title
        tap.addTarget(target, action: sel)
        self.addGestureRecognizer(tap)
    }
    private
    func configureUI() -> Void {
        addSubview(icon)
        addSubview(name)
        icon.snp.makeConstraints{
            $0.top.centerX.equalToSuperview()
        }
        name.snp.makeConstraints{
            $0.top.equalTo(icon.snp.bottom).offset(kAutoHei(8))
            $0.centerX.equalToSuperview()
        }
    }
}
