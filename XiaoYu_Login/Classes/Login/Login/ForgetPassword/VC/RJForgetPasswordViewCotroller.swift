//
//  RJForgetPasswordViewCotroller.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/16.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
enum RJForetPasswordStep{
    case getPhoneNumber
    case verifyCode
    case resetPassword
}
class RJForgetPasswordViewController: RJBaseViewController {
    var phoneNumber                    : String?
    var verifyCode                     : String?
    var Step                           : RJForetPasswordStep = .getPhoneNumber
    
    private
    lazy var accountComponent :RJAccountComponent  = {
        
        var component = RJAccountComponent(type: .forgetPassword_GetPhoneNumber)
        switch Step {
        case .verifyCode:
            component = RJAccountComponent(type: .forgetPassword_VerifyCode)
            component.phoneNumberWhichGetVerifyCode = phoneNumber
        case .resetPassword:
            component = RJAccountComponent(type: .forgetPassword_ResetPassword)
            component.phoneNumberWhichGetVerifyCode = phoneNumber
            component.verifyCode                    = verifyCode
        default:
            break
        }
        return component
    }()
    //MARK: - ViewControllerLifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureUI()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
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
    private
    func configureUI() -> Void {
        addSubview(accountComponent)
        handleAccountComponentEventResonce()
        
        accountComponent.snp.makeConstraints{
            $0.top.equalTo(view.snp.topMargin).offset(kAutoHei(45))
            $0.left.right.equalToSuperview()
        }
    }
    internal
    override func configureNavigation() {
        navBarTitle(LoginLocation("Reset Password"))
    }
    private
    func handleAccountComponentEventResonce() -> Void {
        accountComponent.loginOrRegisterColuse = {(account:String?,password:String?,verifyCode:String?) in
            if RJAPPModel.currentLanguage() != .SimpleChinese {
                self.resetPasswordByPhone(account,password,verifyCode)
            }else{
                self.resetPasswordByEmail(account,password,verifyCode)
            }
           
        }
    }
    private
    func resetPasswordByPhone(_ account:String?,_ password:String?,_ verifyCode:String?) -> Void {
        switch self.Step {
        case .getPhoneNumber:
            let verifyCodeVC = RJForgetPasswordViewController()
            verifyCodeVC.Step = .verifyCode
            verifyCodeVC.phoneNumber = account
            self.navigationController?.pushViewController(verifyCodeVC, animated: true)
        case .verifyCode:
            let resetPasswordVC = RJForgetPasswordViewController()
            resetPasswordVC.Step = .resetPassword
            resetPasswordVC.phoneNumber = self.phoneNumber
            resetPasswordVC.verifyCode  = account
            self.navigationController?.pushViewController(resetPasswordVC, animated: true)
        case .resetPassword:
            RJLoginHelper.resetPasswordByPhone(self.phoneNumber, account, self.verifyCode){ (success, result, error) in
                if success {
                    print("成功\(String(describing: result))")
                }else{
                    print("失败\(String(describing: result))")
                }
            }
            break
        }
    }
    private
    func resetPasswordByEmail(_ account:String?,_ password:String?,_ verifyCode:String?) -> Void {
        RJLoginHelper.resetPasswordByEmail(account) { (success, result, error) in
            if success {
                print("成功\(String(describing: result))")
            }else{
                print("失败\(String(describing: result))")
            }
        }
    }
    //MARK: - Event Reponce
    
}
