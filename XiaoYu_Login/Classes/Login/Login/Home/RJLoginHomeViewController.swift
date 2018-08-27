//
//  RJLoginMainViewController.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/7.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
class RJLoginHomeViewController: RJBaseViewController {
    private lazy var background_imageView:UIImageView = {
        let imageview   = UIImageView()
        
        imageview.image = UIImage.currentBoudle(LoginLocation("login_main_background"), RJLoginHelper.self)
        return imageview
    }()
    private lazy var logo_imageview:UIImageView = {
        let imageview   = UIImageView()
        imageview.image = UIImage.currentBoudle(LoginLocation("login_main_logo"), RJLoginHelper.self)
        return imageview
    }()
    private lazy var facebook_Btn: UIButton = {
        let btn              = UIButton.init(type: .custom)
        btn.backgroundColor  = facebookBtnColor
        btn.titleLabel?.font = RJFontMedium(15.0)
        btn.setTitleColor(.white, for: .normal)
        btn.titleEdgeInsets  = UIEdgeInsetsMake(0, kAutoWid(20), 0, 0)
        btn.setImage(UIImage.currentBoudle(LoginLocation("login_home_facebook_icon"), RJLoginHelper.self), for: .normal)
        btn.setTitle(LoginLocation("Facebook"), for: .normal)
        btn.addTarget(self, action: #selector(facebookBtnClick), for: .touchUpInside)
        return btn
    }()
    private lazy var other_Btn: UIButton = {
        let btn              = UIButton.init(type: .custom)
        btn.titleLabel?.font = RJFontMedium(15.0)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle(LoginLocation("Other"), for: .normal)
        btn.addTarget(self, action: #selector(otherBtnClick), for: .touchUpInside)
        
        btn.cornerCutWith(kAutoHei(20.5))
        return btn
    }()
    private lazy var privacy_Label: UILabel = {
        let label             = UILabel()
        
        let text              = LoginLocation("By signing up,you agree to our ")
        var textAttrString    = NSMutableAttributedString.init(string: text)
        textAttrString.addAttribute(.font, value: RJFontMedium(10.0), range: NSRange(location: 0, length: text.count))
        let privacy           = LoginLocation("Privacy")
        var privacyAttrString = NSMutableAttributedString.init(string: privacy)
        privacyAttrString.addAttribute(.font, value: RJFontMedium(10.0), range: NSRange(location: 0, length: privacy.count))
        privacyAttrString.addAttribute(.underlineStyle, value: NSNumber.init(value: Int8(NSUnderlineStyle.styleSingle.rawValue)), range: NSRange(location: 0, length: privacy.count))
        textAttrString.append(privacyAttrString)
        
        label.attributedText = textAttrString
        label.textColor      = privacyLabelColor
        label.textAlignment  = .center
        label.isUserInteractionEnabled = true
        
        let tap    = UITapGestureRecognizer.init(target: self, action: #selector(privacyLabelTap))
        label.addGestureRecognizer(tap)
        return label
    }()
    //MARK: - ViewControllerLifeCircle
    override
    func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    private
    func configureUI() {
        
        view.addSubview(background_imageView)
        view.addSubview(logo_imageview)
        view.addSubview(facebook_Btn)
        view.addSubview(other_Btn)
        view.addSubview(privacy_Label)
        
        background_imageView.snp.makeConstraints{
            $0.top.left.right.bottom.equalToSuperview()
        }
        logo_imageview.snp.makeConstraints{
            $0.top.equalTo(view.snp.topMargin).offset(kAutoHei(15))
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: kAutoWid(90), height: kAutoHei(116)))
        }
        facebook_Btn.snp.makeConstraints{
            $0.left.equalToSuperview().offset(kAutoWid(21))
            $0.right.equalToSuperview().offset(kAutoWid(-21))
            $0.height.equalTo(kAutoHei(41))
            $0.bottom.equalTo(other_Btn.snp.top).offset(kAutoHei(-20))
        }
        other_Btn.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottomMargin).offset(kAutoHei(-90))
            $0.size.equalTo(facebook_Btn)
        }
        privacy_Label.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(other_Btn.snp.bottom).offset(kAutoHei(28))
        }
    }
    override
    func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        facebook_Btn.cornerCutWith(kAutoHei(20.5))
        other_Btn.cornerCutWith(kAutoHei(20.5), 1.0, .white)
        
    }
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    override
    func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    //MARK: - Event Responce
    @objc
    private
    func facebookBtnClick() -> Void {
        var type :RJLoginInPlatformType = .facebook
        if RJAPPModel.currentLanguage() == .SimpleChinese {
            type = .wechat
        }
        RJLoginHelper.mobAuthorize(type, nil) { (state, userInfo, error) in
            if state == .success {
                guard let errDesc = userInfo else { return }
                let openId = errDesc["uid"] as! String
                let token = errDesc["token"] as! String
                RJLoginHelper.ThirdPlatformLogin(openId, token, .wechat, { (success, result, error) in
                    if success{
                        self.loginSuccess(result)
                    }else{
                        self.loginFail(result, error)
                    }
                })
            }
            if state == .fail {
                RJProgressHUD.showMessage(LoginLocation("Authorization failure"), in: self.view)
            }
            if state == .cancel {
                RJProgressHUD.showMessage(LoginLocation("Cancel the authorization"), in: self.view)
            }
        }
    }
    private
    func loginSuccess(_ result:Any?) -> Void {
        print("登录成功 \(String(describing: result))")
        if result is [AnyHashable : Any] && result != nil{
            let errDesc = result as! [AnyHashable : Any]
            let ID = errDesc["ID"] as! Int
            RJPersonInformationModel.sharePerson.ID = ID
            let IsFirstLogin = errDesc["IsFirstLogin"] as! String
            if IsFirstLogin == "1" {
                self.pushFillInInformationVC()
            }
        }
    }
    private
    func loginFail(_ result:Any?, _ error:Error?) -> Void {
        print("登录失败 \(String(describing: result)),\(String(describing: error))")
        if result is String && result != nil {
            let errDesc = result as! String
             RJProgressHUD.showMessage("\(errDesc)", in: view)
        }
       
    }
    private
    func pushFillInInformationVC() -> Void {
        let fillIn = RJFillInPersonalInformationViewController()
        UIApplication.shared.keyWindow?.rootViewController = RJNavigationController(rootViewController: fillIn)
    }
    @objc
    private
    func otherBtnClick() -> Void {
        let loginByOther = RJLoginViewController()
        navigationController?.pushViewController(loginByOther, animated: true);
    }
    @objc
    private
    func privacyLabelTap() -> Void {
        let privacyWebVC = RJInformationWebViewController()
        privacyWebVC.infomationUrl = LoginLocation("PrivacyURL")
        privacyWebVC.titleString   = LoginLocation("PrivacyTitle")
        navigationController?.pushViewController(privacyWebVC, animated: true);
    }
}
