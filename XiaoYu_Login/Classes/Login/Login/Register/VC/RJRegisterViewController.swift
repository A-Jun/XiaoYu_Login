//
//  RJRegist.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/14.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
class RJRegisterViewController: RJBaseViewController {
    
    private
    lazy var accountComponent: RJAccountComponent = {
        let commonent = RJAccountComponent(type: .register)
        return commonent
    }()
    //MARK: - ViewControllerLifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureUI()
        handleAccountComponentEventResonce()
        
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
        accountComponent.snp.makeConstraints{
            $0.top.equalTo(view.snp.topMargin).offset(kAutoHei(45))
            $0.left.right.equalToSuperview()
        }
    }
    internal
    override func configureNavigation() {
        navBarTitle(LoginLocation("Let's get started"))
        
    }
    private
    func handleAccountComponentEventResonce() -> Void {
        accountComponent.loginOrRegisterColuse = {(account:String?,password:String?,verifyCode:String?) in
            if RJAPPModel.currentLanguage() == .SimpleChinese {
                RJLoginHelper.registerByPhone(account, password, verifyCode){ (success, result, error) in
                    if success {
                        self.registSuccess(result)
                    }else{
                        self.registFail(result, error)
                    }
                }
            }else{
                RJLoginHelper.registerByEmail(account, password){ (success, result, error) in
                    if success {
                        self.registSuccess(result)
                    }else{
                        self.registFail(result, error)
                    }
                }
            }
        }
        accountComponent.eventRespnceColuse = {(type:AccountComponentEventRespnceType, sender:Any?) in
            if type == .registered {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    private
    func registSuccess(_ result:Any?) -> Void {
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
    func registFail(_ result:Any?, _ error:Error?) -> Void {
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
   
}

