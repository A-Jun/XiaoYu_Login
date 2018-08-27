//
//  RJLoginOtherComponent.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/11.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit

typealias LoginTypeSelectedColuse = (_ type:RJLoginInPlatformType)->Void
class RJLoginRecommendComponent: UIView {
    var loginSelected:LoginTypeSelectedColuse?
    
    private
    lazy var leftLine: UIView = {
        let view = UIView()
        view.backgroundColor = splitColor
        return view
    }()
    private
    lazy var recommendLabel: UILabel = {
        let label = UILabel()
        label.text  = LoginLocation("or log in with")
        label.textColor = grayTextColor
        label.font = RJFontMedium(11)
        return label
    }()
    private
    lazy var rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = splitColor
        return view
    }()
    private
    lazy var quickLogin: RJLoginTypeView = {
        let view = RJLoginTypeView(image: UIImage.currentBoudle(LoginLocation("login_wechat_icon"), RJLoginHelper.self), title: LoginLocation("Wechat"), target:self ,sel: #selector(quickLoginClick))
        return view
    }()
    lazy var wechtLogin: RJLoginTypeView = {
        let view = RJLoginTypeView(image: UIImage.currentBoudle(LoginLocation("login_facebook_icon"), RJLoginHelper.self), title: LoginLocation("Facebook"), target:self ,sel: #selector(wechatLoginClick))
        return view
    }()
    lazy var QQLogin: RJLoginTypeView = {
        let view = RJLoginTypeView(image: UIImage.currentBoudle(LoginLocation("login_twitter_icon"), RJLoginHelper.self), title: LoginLocation("Twitter"), target:self , sel: #selector(QQLoginClick))
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private
    func configureUI() -> Void {
        addSubview(leftLine)
        addSubview(recommendLabel)
        addSubview(rightLine)
        addSubview(quickLogin)
        addSubview(wechtLogin)
        addSubview(QQLogin)
        
        leftLine.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalTo(recommendLabel)
            $0.right.equalTo(recommendLabel.snp.left).offset(kAutoWid(-10))
            $0.height.equalTo(kAutoHei(1))
        }
        recommendLabel.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        rightLine.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(recommendLabel)
            $0.left.equalTo(recommendLabel.snp.right).offset(kAutoWid(10))
            $0.height.equalTo(kAutoHei(1))
        }
        
        quickLogin.snp.makeConstraints{
            $0.height.equalTo(kAutoHei(90))
            $0.left.bottom.equalToSuperview()
            $0.right.equalTo(wechtLogin.snp.left)
        }
        wechtLogin.snp.makeConstraints{
            $0.width.height.equalTo(quickLogin)
            $0.bottom.equalToSuperview()
            $0.right.equalTo(QQLogin.snp.left)
        }
        QQLogin.snp.makeConstraints{
            $0.width.height.equalTo(quickLogin)
            $0.bottom.right.equalToSuperview()
        }
    }
    //MARK: - Event Responce
    @objc
    private
    func quickLoginClick(_ tapView:RJLoginTypeView) -> Void {
        guard let coluse = loginSelected else { return  }
        if RJAPPModel.currentLanguage() == .SimpleChinese {
            coluse(.phoneQuick)
        }else{
            coluse(.wechat)
        }
        
    }
    @objc
    private
    func wechatLoginClick(_ tapView:RJLoginTypeView) -> Void {
        guard let coluse = loginSelected else { return  }
        if RJAPPModel.currentLanguage() == .SimpleChinese {
            coluse(.wechat)
        }else{
            coluse(.facebook)
        }
    }
    @objc
    private
    func QQLoginClick(_ tapView:RJLoginTypeView) -> Void {
        guard let coluse = loginSelected else { return  }
        if RJAPPModel.currentLanguage() == .SimpleChinese {
            coluse(.QQ)
        }else{
            coluse(.twitter)
        }
    }
}
