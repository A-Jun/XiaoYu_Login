//
//  RJLoginComponet.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/11.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
enum AccountComponentType {
    case login_Account
    case login_phoneQuick
    case register
    case forgetPassword_GetPhoneNumber
    case forgetPassword_VerifyCode
    case forgetPassword_ResetPassword
}
enum AccountComponentEventRespnceType {
    case register
    case forgetPW
    case registered
}

typealias LoginOrRegisterColuse              = (_ account:String?, _ password:String? ,_ verifyCode:String?)->Void
typealias EventRespnceColuse                 = (_ type : AccountComponentEventRespnceType , _ sender : Any?)->Void
let keybordMagin = kAutoHei(20)



class RJAccountComponent: UIView {
    var loginOrRegisterColuse          : LoginOrRegisterColuse?
    var eventRespnceColuse             : EventRespnceColuse?
    var changeStateTimer               : Timer?
    var verifyCodeTimer                : Timer?
    var verifyCodeAgainTimes           : Int = 60
    var phoneNumberWhichGetVerifyCode  : String?
    var verifyCode                     : String?
    
    
    private
    var type         : AccountComponentType = .login_Account
    private
    lazy var prompt : UILabel = {
        let label = UILabel()
        label.textColor = grayTextColor
        label.font      = RJFontMedium(15)
        label.numberOfLines = 0;
        return label
    }()
    private
    lazy var accountTF: RJTextField = {
        let textField = RJTextField()
        return textField
    }()
    private
    lazy var passwordTF: RJTextField = {
        let textField             = RJTextField()
        return textField
    }()
    private
    lazy var passwordVerifyTF: RJTextField = {
        let textField             = RJTextField()
        return textField
    }()
    private
    lazy var loginOrRegisterBtn : UIButton = {
        let btn              = UIButton.init(type: .custom)
        btn.backgroundColor  = .clear
        btn.titleLabel?.font = RJFontMedium(15)
        btn.setTitleColor(loginBtnUnableColor, for: .normal)
        btn.addTarget(self, action: #selector(loginOrRegisterBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    private
    lazy var registBtn : UIButton = {
        let btn              = UIButton.init(type: .custom)
        btn.backgroundColor  = .clear
        btn.titleLabel?.font = RJFontMedium(13)
        btn.setTitleColor(grayTextColor, for: .normal)
        btn.setTitle(LoginLocation("Register"), for: .normal)
        btn.addTarget(self, action: #selector(registerBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    private
    lazy var registeredBtn : UIButton = {
        let btn              = UIButton.init(type: .custom)
        btn.backgroundColor  = .clear
        btn.titleLabel?.font = RJFontMedium(13)
        btn.setTitleColor(grayTextColor, for: .normal)
        btn.setTitle(LoginLocation("I've a Coollang account"), for: .normal)
        btn.addTarget(self, action: #selector(registeredBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    private
    lazy var forgetPWBtn : UIButton = {
        let btn              = UIButton.init(type: .custom)
        btn.backgroundColor  = .clear
        btn.titleLabel?.font = RJFontMedium(13)
        btn.setTitleColor(grayTextColor, for: .normal)
        btn.setTitle(LoginLocation("Forget password?"), for: .normal)
        btn.addTarget(self, action: #selector(forgetPWBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    internal
    init() {
        super.init(frame:.zero)
//        creatTimerChangeLoginOrRegisterButtonState()
    }
    convenience
    init(type:AccountComponentType) {
        self.init()
        self.type = type
        switch type {
        case .login_Account:
            configureUIForAccountLogin()
        case .login_phoneQuick:
            configureUIForPhoneQuickLogin()
        case .register:
            configureUIForPhoneRegist()
        case .forgetPassword_GetPhoneNumber:
            configureUIForForgetPassword_GetPhoneNumber()
        case .forgetPassword_VerifyCode:
            configureUIForForgetPassword_VerifyCode()
        case .forgetPassword_ResetPassword:
            configureUIForForgetPassword_ResetPassword()
        }
        
        creatTimerChangeLoginOrRegisterButtonState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLoginOrRegistBtnTitle(_ title:String?) -> Void {
        loginOrRegisterBtn.setTitle(title, for: .normal)
        loginOrRegisterBtn.sizeToFit()
        loginOrRegisterBtn.size = CGSize(width:kScreenW - kAutoWid(42), height: kAutoHei(41))
        loginOrRegisterBtn.cornerCutWith(kAutoHei(20.5), 1.0, loginBtnUnableColor)
    }
    func promptText(_ title:String?) -> Void {
        prompt.text = title
    }
    //MARK: Event Responce
    @objc
    private
    func showPasswordClick(_ button:UIButton) -> Void {
        button.isSelected = !button.isSelected
        let textField = button.superview as! RJTextField
        textField.isSecureTextEntry = !button.isSelected
        let text = textField.text
        textField.text = ""
        textField.text = text
    }
    @objc
    private
    func acquireVerifyCode(_ button:UIButton) -> Void {
        
        var phone :String?
        if type == .forgetPassword_VerifyCode {
            phone = phoneNumberWhichGetVerifyCode
        }else{
            phone = accountTF.text
        }
        
        guard let phoneNum = phone else { return  }
        if RJLoginHelper.phoneNumberCheck(phoneNum) {
            
            
            RJLoginHelper.mobGetVerifyCode(.SMS, phoneNum, "86", "") {
                if $0 == nil {
                    print("请求成功")
                    self.acquireVerifyCodeAgainOneMinuteTimerLater(button)
                }else{
                    print("请求失败")
                }
            }
        }
    }
    private
    func acquireVerifyCodeAgainOneMinuteTimerLater(_ button:UIButton) -> Void {
        button.isEnabled = false
        button.setTitle("获取验证码", for: .normal)
        DispatchQueue.global().async {
            self.verifyCodeAgainTimes = 59
            self.verifyCodeTimer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(self.changeText(_:)), userInfo: ["button":button], repeats: true)
            let runloop = RunLoop.current
            runloop.add(self.verifyCodeTimer!, forMode: .commonModes)
            runloop.run()
        }
    }
    @objc
    func changeText(_ timer:Timer) -> Void {
        guard let dict = timer.userInfo  else { return  }
        let userInfo = dict as! [AnyHashable:Any]
        guard let button = userInfo["button"] else { return  }
        let verifyCodeBtn = button as! UIButton
        var title = String(format: "%d", verifyCodeAgainTimes)
        DispatchQueue.main.async {
            if self.verifyCodeAgainTimes == 0 {
                verifyCodeBtn.isEnabled = false
                title = "获取验证码"
                self.verifyCodeTimer?.invalidate()
                self.verifyCodeTimer = nil
            }
            verifyCodeBtn.setTitle(title, for: .normal)
        }
        verifyCodeAgainTimes -= 1
        
    }
    //MARK: Notification
    private
    func registNotification() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange), name: Notification.Name.UITextFieldTextDidChange, object: accountTF)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    private
    func removeNotification() -> Void {
        NotificationCenter.default.removeObserver(self)
    }
    @objc
    private
    func textFieldTextDidChange(_ notification:Notification) -> Void {
        
    }
    @objc
    private
    func keybordWillShow(_ notification:Notification) -> Void {
        let duration      = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let keyboardRect  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let keybord_y     = keyboardRect.origin.y
        let loginOrRegisterBtn_MaxY = loginOrRegisterBtn.frame.maxY
        let value = keybord_y - loginOrRegisterBtn_MaxY - keybordMagin
        
        if  value > 0 {
            return
        }else{
            UIView.animate(withDuration: duration) {
                UIApplication.shared.keyWindow?.y -= value
            }
        }
    }
    @objc
    private
    func keybordWillHide(_ notification:Notification) -> Void {
        let duration      = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: duration) {
            UIApplication.shared.keyWindow?.y = 0
        }
    }
    
    //MARK:  Observe
    private
    func creatTimerChangeLoginOrRegisterButtonState() -> Void {
        DispatchQueue.global().async {
            self.changeStateTimer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(self.changeLoginOrRegisterButtonState(_:)), userInfo: nil, repeats: true)
            let runloop = RunLoop.current
            runloop.add(self.changeStateTimer!, forMode: .commonModes)
            runloop.run()
        }
        
    }
    @objc
    private
    func changeLoginOrRegisterButtonState(_ sender:Timer) -> Void {
        DispatchQueue.main.async {
            if self.type == .login_Account || self.type == .login_phoneQuick {
                self.loginOrRegisterButtonEnableAtLoginPage()
            }
            if self.type == .register {
                self.loginOrRegisterButtonEnableAtRegisterPage()
            }
            if self.type == .forgetPassword_GetPhoneNumber {
                self.loginOrRegisterButtonEnableAtForgetPassword_GetPhoneNumberPage()
            }
            if self.type == .forgetPassword_VerifyCode {
                self.loginOrRegisterButtonEnableAtForgetPassword_VerifyCodePage()
            }
            if self.type == .forgetPassword_ResetPassword {
                self.loginOrRegisterButtonEnableAtForgetPassword_ResetPassword()
            }
            if self.loginOrRegisterBtn.isEnabled {
                self.loginOrRegisterBtn.cornerCutWith(kAutoHei(20.5), 1.0, loginBtnEnableColor)
                self.loginOrRegisterBtn.setTitleColor(loginBtnEnableColor, for: .normal)
            }
        }
        
    }
    private
    func loginOrRegisterButtonEnableAtLoginPage() -> Void {
        if accountTF.text?.count != 0   && passwordTF.text?.count != 0  {
            loginOrRegisterBtn.isEnabled = emailOrPhoneNumberCheck(accountTF.text)
        }else{
            loginOrRegisterBtn.isEnabled = false
        }
    }
    
    private
    func loginOrRegisterButtonEnableAtRegisterPage() -> Void {
        if accountTF.text?.count != 0 && passwordTF.text?.count != 0 && passwordVerifyTF.text?.count != 0 {
            loginOrRegisterBtn.isEnabled = emailOrPhoneNumberCheck(accountTF.text)
        }else{
            self.loginOrRegisterBtn.isEnabled = false
        }
    }
    private
    func loginOrRegisterButtonEnableAtForgetPassword_GetPhoneNumberPage() -> Void {
        if accountTF.text?.count != 0 {
            loginOrRegisterBtn.isEnabled = emailOrPhoneNumberCheck(accountTF.text)
        }else{
            loginOrRegisterBtn.isEnabled = false
        }
    }
    private
    func loginOrRegisterButtonEnableAtForgetPassword_VerifyCodePage() -> Void {
        if accountTF.text?.count != 0 && accountTF.text?.count == 4{
            loginOrRegisterBtn.isEnabled = true
        }else{
            loginOrRegisterBtn.isEnabled = false
        }
    }
    private
    func loginOrRegisterButtonEnableAtForgetPassword_ResetPassword() -> Void {
        if (accountTF.text?.count)! != 0 && (accountTF.text?.count)! >= 6 && accountTF.text == passwordTF.text{
            loginOrRegisterBtn.isEnabled = true
        }else{
            loginOrRegisterBtn.isEnabled = false
        }
    }
    private
    func emailOrPhoneNumberCheck(_ text:String?) -> Bool {
        if RJAPPModel.currentLanguage() == .SimpleChinese {
            return RJLoginHelper.phoneNumberCheck(text)
        }else{
            return RJLoginHelper.emailCheck(text)
        }
    }
    deinit {
        removeNotification()
        changeStateTimer?.invalidate()
        changeStateTimer = nil
    }
}
//MARK: - Account Login
extension RJAccountComponent{
    private
    func configureUIForAccountLogin() -> Void {
        let logoImage = UIImage.currentBoudle(LoginLocation("login_register_phone_icon"), RJLoginHelper.self)
        var keyboardType : UIKeyboardType = .emailAddress
        if RJAPPModel.currentLanguage() == .SimpleChinese {
            keyboardType = .phonePad
            accountTF.maxLength = 11
        }
        accountTF.keyboardType = keyboardType
        accountTF.setLogoBtn(image: logoImage, state: .normal)
        accountTF.attributedPlaceholder = NSMutableAttributedString(string: LoginLocation("Enter Email Address"), attributes: [NSAttributedStringKey.foregroundColor : grayTextColor])
        accountTF.configureLayout()
        addSubview(accountTF)
        
        let logoImage_pw             = UIImage.currentBoudle(LoginLocation("login_password_icon"), RJLoginHelper.self)
        let functionImage_pw         = UIImage.currentBoudle(LoginLocation("login_password_hidden"), RJLoginHelper.self)
        let functionSelectedImage_pw = UIImage.currentBoudle(LoginLocation("login_password_readable"), RJLoginHelper.self)
        let placeholder_pw           = LoginLocation("Password")
        let action                   = #selector(showPasswordClick)
        passwordTF.setLogoBtn(image: logoImage_pw, state: .normal)
        passwordTF.setFunctionBtn(image: functionImage_pw, title: nil, state: .normal)
        passwordTF.setFunctionBtn(image: functionSelectedImage_pw, title: nil, state: .selected)
        passwordTF.attributedPlaceholder = NSMutableAttributedString(string: placeholder_pw, attributes: [NSAttributedStringKey.foregroundColor : grayTextColor])
        passwordTF.addTargetForFunctionBtn(self, anction: action, enent: .touchUpInside)
        passwordTF.isSecureTextEntry = true
        passwordTF.configureLayout()
        addSubview(passwordTF)
        
        setLoginOrRegistBtnTitle(LoginLocation("Log in"))
        addSubview(loginOrRegisterBtn)
        
        addSubview(registBtn)
        addSubview(forgetPWBtn)
        
        accountTF.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(kAutoHei(45))
        }
        passwordTF.snp.makeConstraints{
            $0.top.equalTo(accountTF.snp.bottom)
            $0.left.right.equalTo(accountTF)
            $0.height.equalTo(kAutoHei(45))
        }
        loginOrRegisterBtn.snp.makeConstraints{
            $0.top.equalTo(passwordTF.snp.bottom).offset(kAutoHei(30))
            $0.height.equalTo(kAutoHei(41))
            $0.left.equalToSuperview().offset(kAutoWid(21))
            $0.right.equalToSuperview().offset(kAutoWid(-21))
        }
        registBtn.snp.makeConstraints{
            $0.top.equalTo(loginOrRegisterBtn.snp.bottom).offset(kAutoHei(8))
            $0.left.equalTo(loginOrRegisterBtn)
        }
        forgetPWBtn.snp.makeConstraints{
            $0.top.equalTo(loginOrRegisterBtn.snp.bottom).offset(kAutoHei(8))
            $0.right.equalTo(loginOrRegisterBtn)
            $0.bottom.equalToSuperview()
        }
        
    }
    //MARK: Event Responce
    @objc
    private
    func loginOrRegisterBtnClick(_ button:UIButton) -> Void {
        guard let coluse = loginOrRegisterColuse else { return  }
        coluse(accountTF.text,passwordTF.text,passwordVerifyTF.text)
    }
    @objc
    private
    func registerBtnClick(_ button:UIButton) -> Void {
        guard let coluse = eventRespnceColuse else { return  }
        coluse(.register,button)
    }
    @objc
    private
    func forgetPWBtnClick(_ button:UIButton) -> Void {
        guard let coluse = eventRespnceColuse else { return  }
        coluse(.forgetPW,button)
    }
    
}
//MARK: - Phone Login
extension RJAccountComponent{
    private
    func configureUIForPhoneQuickLogin() -> Void {
        
        let logoImage = UIImage.currentBoudle(LoginLocation("login_register_phone_icon"), RJLoginHelper.self)
        accountTF.keyboardType = .phonePad
        accountTF.maxLength = 11
        accountTF.setLogoBtn(image: logoImage, state: .normal)
        accountTF.attributedPlaceholder = NSMutableAttributedString(string: LoginLocation("Enter Email Address"), attributes: [NSAttributedStringKey.foregroundColor : grayTextColor])
        accountTF.configureLayout()
        addSubview(accountTF)
       
        let logoImage_pw             = UIImage.currentBoudle(LoginLocation("login_verify_icon"), RJLoginHelper.self)
        let functionTitle_pw         = LoginLocation("  获取验证码  ")
        let placeholder_pw           = LoginLocation("请输入验证码")
        let action                   = #selector(acquireVerifyCode(_:))
        
        passwordTF.maxLength         = 4
        passwordTF.setLogoBtn(image: logoImage_pw, state: .normal)
        passwordTF.setFunctionBtn(image: nil, title: functionTitle_pw, state: .normal)
        passwordTF.attributedPlaceholder = NSMutableAttributedString(string: placeholder_pw, attributes: [NSAttributedStringKey.foregroundColor : grayTextColor])
        passwordTF.addTargetForFunctionBtn(self, anction: action, enent: .touchUpInside)
        passwordTF.creatCornerForFunctionBtn()
        passwordTF.configureLayout()
        addSubview(passwordTF)
        
        let text = LoginLocation("确定")
        loginOrRegisterBtn.setTitle(text, for: .normal)
        loginOrRegisterBtn.sizeToFit()
        loginOrRegisterBtn.size = CGSize(width:kScreenW - kAutoWid(42), height: kAutoHei(41))
        loginOrRegisterBtn.cornerCutWith(kAutoHei(20.5), 1.0, grayTextColor)
        addSubview(loginOrRegisterBtn)
        
        
        accountTF.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(kAutoHei(45))
        }
        passwordTF.snp.makeConstraints{
            $0.top.equalTo(accountTF.snp.bottom)
            $0.left.right.equalTo(accountTF)
            $0.height.equalTo(kAutoHei(45))
        }
        loginOrRegisterBtn.snp.makeConstraints{
            $0.top.equalTo(passwordTF.snp.bottom).offset(kAutoHei(30))
            $0.height.equalTo(kAutoHei(41))
            $0.left.equalToSuperview().offset(kAutoWid(21))
            $0.right.equalToSuperview().offset(kAutoWid(-21))
            $0.bottom.equalToSuperview()
        }
    }
}
//MARK: - Regist
extension RJAccountComponent{
    private
    func configureUIForPhoneRegist() -> Void {
        var keyboardType : UIKeyboardType = .emailAddress
        
        if RJAPPModel.currentLanguage() == .SimpleChinese {
            accountTF.maxLength = 11
            keyboardType = .phonePad
        }
        accountTF.keyboardType = keyboardType
        accountTF.attributedPlaceholder = NSMutableAttributedString(string: LoginLocation("your@email.com"), attributes: [NSAttributedStringKey.foregroundColor : grayTextColor])
        accountTF.configureLayout()
        addSubview(accountTF)
        
        let functionImage_pw         = UIImage.currentBoudle(LoginLocation("login_password_hidden"), RJLoginHelper.self)
        let functionSelectedImage_pw = UIImage.currentBoudle(LoginLocation("login_password_readable"), RJLoginHelper.self)
        let placeholder_pw           = LoginLocation("your password")
        var action_pw                = #selector(showPasswordClick)
        if RJAPPModel.currentLanguage() == .SimpleChinese {
            action_pw                = #selector(acquireVerifyCode(_:))
            passwordTF.setFunctionBtn(image: nil, title: LoginLocation("  获取验证码  "), state: .normal)
            passwordTF.maxLength     = 6
            passwordTF.keyboardType  = .phonePad
            passwordTF.creatCornerForFunctionBtn()
        }else{
            passwordTF.setFunctionBtn(image: functionImage_pw, title: nil, state: .normal)
            passwordTF.setFunctionBtn(image: functionSelectedImage_pw, title: nil, state: .selected)
        }
        
        passwordTF.attributedPlaceholder = NSMutableAttributedString(string: placeholder_pw, attributes: [NSAttributedStringKey.foregroundColor : grayTextColor])
        passwordTF.addTargetForFunctionBtn(self, anction: action_pw, enent: .touchUpInside)
        passwordTF.configureLayout()
        addSubview(passwordTF)
        
        
        let functionImage_pw_vefify          = UIImage.currentBoudle(LoginLocation("login_password_hidden"), RJLoginHelper.self)
        let functionSelectedImage_pw_vefify  = UIImage.currentBoudle(LoginLocation("login_password_readable"), RJLoginHelper.self)
        let placeholder_pw_vefify            = LoginLocation("repeat your password")
        let action_pw_vefify                 = #selector(showPasswordClick)
        passwordVerifyTF.setFunctionBtn(image: functionImage_pw_vefify, title: nil, state: .normal)
        passwordVerifyTF.setFunctionBtn(image: functionSelectedImage_pw_vefify, title: nil, state: .selected)
        passwordVerifyTF.attributedPlaceholder = NSMutableAttributedString(string: placeholder_pw_vefify, attributes: [NSAttributedStringKey.foregroundColor : grayTextColor])
        passwordVerifyTF.addTargetForFunctionBtn(self, anction: action_pw_vefify, enent: .touchUpInside)
        passwordVerifyTF.isSecureTextEntry = true
        passwordVerifyTF.configureLayout()
        addSubview(passwordVerifyTF)
        
        setLoginOrRegistBtnTitle(LoginLocation("Join"))
        addSubview(loginOrRegisterBtn)
        
        
        addSubview(registeredBtn)
        
        accountTF.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(kAutoHei(45))
        }
        passwordTF.snp.makeConstraints{
            $0.top.equalTo(accountTF.snp.bottom)
            $0.left.right.equalTo(accountTF)
            $0.height.equalTo(kAutoHei(45))
        }
        passwordVerifyTF.snp.makeConstraints{
            $0.top.equalTo(passwordTF.snp.bottom)
            $0.left.right.equalTo(accountTF)
            $0.height.equalTo(kAutoHei(45))
        }
        loginOrRegisterBtn.snp.makeConstraints{
            $0.top.equalTo(passwordVerifyTF.snp.bottom).offset(kAutoHei(30))
            $0.height.equalTo(kAutoHei(41))
            $0.left.equalToSuperview().offset(kAutoWid(21))
            $0.right.equalToSuperview().offset(kAutoWid(-21))
        }
        registeredBtn.snp.makeConstraints{
            $0.top.equalTo(loginOrRegisterBtn.snp.bottom).offset(kAutoHei(8))
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
    //MARK: Event Responce
    @objc
    private
    func registeredBtnClick(_ button:UIButton) -> Void {
        guard let coluse = eventRespnceColuse else { return  }
        coluse(.registered,button)
    }
}
//MARK: - ForgetPassword_GetPhoneNumber
extension RJAccountComponent {
    private
    func configureUIForForgetPassword_GetPhoneNumber() -> Void {
        prompt.text = LoginLocation("Please enter the email address associated with your Coollang account")
        addSubview(prompt)
        var keyboardType : UIKeyboardType = .emailAddress
        
        if RJAPPModel.currentLanguage() == .SimpleChinese {
            accountTF.maxLength = 11
            keyboardType = .phonePad
        }
        accountTF.keyboardType = keyboardType
        accountTF.attributedPlaceholder = NSMutableAttributedString(string: LoginLocation("your@email.com"), attributes: [NSAttributedStringKey.foregroundColor : grayTextColor])
        accountTF.configureLayout()
        addSubview(accountTF)
        
        setLoginOrRegistBtnTitle(LoginLocation(" Reset Password "))
        addSubview(loginOrRegisterBtn)
        
        prompt.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(kAutoWid(21))
            $0.right.equalToSuperview().offset(kAutoWid(-21))
            $0.height.equalTo(kAutoHei(45))
        }
        accountTF.snp.makeConstraints{
            $0.top.equalTo(prompt.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(kAutoHei(45))
        }
        loginOrRegisterBtn.snp.makeConstraints{
            $0.top.equalTo(accountTF.snp.bottom).offset(kAutoHei(30))
            $0.height.equalTo(kAutoHei(41))
            $0.left.equalToSuperview().offset(kAutoWid(21))
            $0.right.equalToSuperview().offset(kAutoWid(-21))
            $0.bottom.equalToSuperview()
        }
        
    }
}
//MARK: - ForgetPassword_VerifyCode
extension RJAccountComponent {
    private
    func configureUIForForgetPassword_VerifyCode() -> Void {
        let text = LoginLocation("请输入您收到的验证码:\n您的手机号码:  ")
        let textAttri = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor : grayTextColor])
        let phoneAttri = NSMutableAttributedString(string: phoneNumberWhichGetVerifyCode ?? "", attributes: [NSAttributedStringKey.foregroundColor : UIColor.orange])
        textAttri.append(phoneAttri)
        prompt.attributedText = textAttri
        
        addSubview(prompt)
        
        var keyboardType : UIKeyboardType = .emailAddress
        
        if RJAPPModel.currentLanguage() == .SimpleChinese {
            keyboardType = .phonePad
        }
        accountTF.keyboardType = keyboardType
        let functionTitle_pw         = LoginLocation("  获取验证码  ")
        let placeholder_pw           = LoginLocation("请输入验证码")
        let action                   = #selector(acquireVerifyCode(_:))
        
        accountTF.maxLength         = 4
        accountTF.setFunctionBtn(image: nil, title: functionTitle_pw, state: .normal)
        accountTF.attributedPlaceholder = NSMutableAttributedString(string: placeholder_pw, attributes: [NSAttributedStringKey.foregroundColor : grayTextColor])
        accountTF.addTargetForFunctionBtn(self, anction: action, enent: .touchUpInside)
        accountTF.creatCornerForFunctionBtn()
        accountTF.backgroundColor   = UIColor.init(0xffffff, 0.05)
        accountTF.configureLayout()
        addSubview(accountTF)
        
        setLoginOrRegistBtnTitle(LoginLocation("确定"))
        addSubview(loginOrRegisterBtn)
        
        prompt.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(kAutoWid(21))
            $0.right.equalToSuperview().offset(kAutoWid(-21))
            $0.height.equalTo(kAutoHei(45))
        }
        accountTF.snp.makeConstraints{
            $0.top.equalTo(prompt.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(kAutoHei(45))
        }
        loginOrRegisterBtn.snp.makeConstraints{
            $0.top.equalTo(accountTF.snp.bottom).offset(kAutoHei(30))
            $0.height.equalTo(kAutoHei(41))
            $0.left.right.equalTo(prompt)
            $0.bottom.equalToSuperview()
        }
        
    }
}
//MARK: - ForgetPassword_ResetPassword
extension RJAccountComponent {
    private
    func configureUIForForgetPassword_ResetPassword() -> Void {
        prompt.text = LoginLocation("请设置您的账号密码")
        addSubview(prompt)
        
        
        
        let functionImage_pw         = UIImage.currentBoudle(LoginLocation("login_password_hidden"), RJLoginHelper.self)
        let functionSelectedImage_pw = UIImage.currentBoudle(LoginLocation("login_password_readable"), RJLoginHelper.self)
        let placeholder              = LoginLocation("请输入密码")
        let placeholder_pw           = LoginLocation("请重复您输入的密码")
        let action                   = #selector(acquireVerifyCode(_:))
        
        accountTF.setFunctionBtn(image: functionImage_pw, title: nil, state: .normal)
        accountTF.setFunctionBtn(image: functionSelectedImage_pw, title: nil, state: .selected)
        accountTF.attributedPlaceholder = NSMutableAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor : grayTextColor])
        accountTF.addTargetForFunctionBtn(self, anction: action, enent: .touchUpInside)
        accountTF.isSecureTextEntry = true
        accountTF.backgroundColor   = UIColor.init(0xffffff, 0.05)
        accountTF.configureLayout()
        addSubview(accountTF)
        
        passwordTF.setFunctionBtn(image: functionImage_pw, title: nil, state: .normal)
        passwordTF.setFunctionBtn(image: functionSelectedImage_pw, title: nil, state: .selected)
        passwordTF.attributedPlaceholder = NSMutableAttributedString(string: placeholder_pw, attributes: [NSAttributedStringKey.foregroundColor : grayTextColor])
        passwordTF.addTargetForFunctionBtn(self, anction: action, enent: .touchUpInside)
        passwordTF.isSecureTextEntry = true
        passwordTF.backgroundColor   = UIColor.init(0xffffff, 0.05)
        passwordTF.configureLayout()
        addSubview(passwordTF)
        
        setLoginOrRegistBtnTitle(LoginLocation("确定"))
        addSubview(loginOrRegisterBtn)
        
        prompt.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(kAutoWid(21))
            $0.right.equalToSuperview().offset(kAutoWid(-21))
            $0.height.equalTo(kAutoHei(45))
        }
        accountTF.snp.makeConstraints{
            $0.top.equalTo(prompt.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(kAutoHei(45))
        }
        passwordTF.snp.makeConstraints{
            $0.top.equalTo(accountTF.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(kAutoHei(45))
        }
        loginOrRegisterBtn.snp.makeConstraints{
            $0.top.equalTo(passwordTF.snp.bottom).offset(kAutoHei(30))
            $0.height.equalTo(kAutoHei(41))
            $0.left.right.equalTo(prompt)
            $0.bottom.equalToSuperview()
        }
        
    }
}
