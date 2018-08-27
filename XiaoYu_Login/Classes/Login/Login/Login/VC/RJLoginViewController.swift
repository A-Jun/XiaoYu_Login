//
//  RJLoginViewController.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/11.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
enum RJLoginInPlatformType : String{
    case account
    case phoneQuick
    case wechat
    case QQ
    case facebook
    case twitter
}
class RJLoginViewController: RJBaseViewController {
    var loginType :RJLoginInPlatformType = .account
    
    private
    lazy var accountCommonent: RJAccountComponent = {
        var commonent = RJAccountComponent(type: .login_Account)
        if loginType == .phoneQuick {
            commonent = RJAccountComponent(type:.login_phoneQuick)
        }
        
        return commonent
    }()
    private
    lazy var recommendCommonent: RJLoginRecommendComponent = {
        let commonent = RJLoginRecommendComponent()
        commonent.loginSelected = {
            if $0 == .phoneQuick {
                self.phoneQuickLogin()
            }else{
                self.thirdLogin($0)
            }
            
        }
        return commonent
    }()
    
    
    
    //MARK: - ViewControllerLifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        switch loginType {
        case .account:
            configureUIForAccoundLogin()
        case .phoneQuick:
            configureUIForphoneQuickLogin()
        default:
            break
        }
        handleAccountComponentEventResonce()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    internal
    override func configureNavigation() {
        
        navBarTitle(LoginLocation("Log in to Coollang"))
        
    }
    private
    func handleAccountComponentEventResonce() -> Void {
        accountCommonent.loginOrRegisterColuse = {(account:String?,password:String?,verifyCode:String?) in
            if self.loginType == .account {
                RJLoginHelper.LoginByAccount(account, password){ (success,result,error) in
                    if success{
                        self.loginSuccess(result)
                    }else{
                        self.loginFail(result, error)
                    }
                }
            }
            if self.loginType == .phoneQuick {
                RJLoginHelper.QuickLoginByPhone(account, password, { (success,result,error) in
                    if success{
                        self.loginSuccess(result)
                    }else{
                       self.loginFail(result, error)
                    }
                })
            }
           
        }
        accountCommonent.eventRespnceColuse = {(type:AccountComponentEventRespnceType, sender:Any?) in
            if type == .register {
                let registerVC = RJRegisterViewController()
                self.navigationController?.pushViewController(registerVC, animated: true)
            }
            if type == .forgetPW {
                let forgetPWVC = RJForgetPasswordViewController()
                self.navigationController?.pushViewController(forgetPWVC, animated: true)
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
    //MARK: - Event Reponce
    private
    func phoneQuickLogin() -> Void {
        let phoneVC = RJLoginViewController()
        phoneVC.loginType = .phoneQuick
        navigationController?.pushViewController(phoneVC, animated: true)
    }
    private
    func thirdLogin(_ loginType:RJLoginInPlatformType) -> Void {
        RJLoginHelper.mobAuthorize(loginType, nil) { (state, userInfo, error) in
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
}
//MARK: - Accound Login
extension RJLoginViewController{
    private
    func configureUIForAccoundLogin() -> Void {
        
        addSubview(accountCommonent)
        addSubview(recommendCommonent)
        accountCommonent.snp.makeConstraints{
            $0.top.equalTo(view.snp.topMargin).offset(kAutoHei(45))
            $0.left.right.equalToSuperview()
        }
        recommendCommonent.snp.makeConstraints{
            $0.height.equalTo(kAutoHei(145))
            $0.left.right.equalTo(accountCommonent)
            $0.bottom.equalTo(view.snp.bottomMargin).offset(kAutoHei(-31))
        }
        
    }
}
//MARK: - Phone Login
extension RJLoginViewController{
    private
    func configureUIForphoneQuickLogin() -> Void {
        addSubview(accountCommonent)
        accountCommonent.snp.makeConstraints{
            $0.top.equalTo(view.snp.topMargin).offset(kAutoHei(45))
            $0.left.right.equalToSuperview()
        }
    }
}
