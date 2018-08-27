//
//  RJLoginHelper.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/15.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
@_exported import SnapKit
@_exported import XiaoYu_Network
@_exported import XiaoYuKit
@_exported import RJProgressHUD
@_exported import CTMediator
enum LoginAPIType : String{
    case PhoneRegistered
    case RegisterByPhone
    case RegisterByEmail
    case LoginByAccount
    case QuickLoginByPhone
    case ThirdPlatformLogin
    case GetVerifyCodeByPhone
    case ResetPasswordByPhone
    case ResetPasswordByEmail
    case ModifyPassword
    case BindThirdPlatform
    case BindPhone
    case GetAccountBindInfo
    case RelieveBind
    case SavePersonInfo
}

enum RJMobShareAuthorizeState :String {
    case begin                  //开始
    case success                //成功
    case fail                   //失败
    case cancel                 //取消
    case beginUPLoad            //视频文件开始上传
}
enum RJMobGetVefifyCodeMethod :String {
    case SMS
    case Vioce
}
let kAPPVersionForMobSDK  = "3"
let kAPPVersionForNetWork = "3"



typealias AuthorizeStateChangedHandler = (_ state:RJMobShareAuthorizeState,_ userInfo:[AnyHashable:Any]?,_ errorInfo:Error?)->Void
typealias GetVerifyCodeHandler    = (_ error:Error?) -> Void

typealias NetworkHandler               = (_ success:Bool, _ resultInfo:Any? , _ error:NSError?)->Void

class RJLoginHelper: NSObject {
    private var account        :String?
    private var password       :String?
    private var passwordVerify :String?
    private var phoneNumber    :String?
    private var verifyCode     :String?
    private var email          :String?
    private var openId         :String?
    private var token          :String?
    private var thirdPlatformType  :RJLoginInPlatformType = .QQ
    
    class
    func endLoginComponent() -> Void {
        
        
    }
    
    //MARK: - Mob
    class func mobAuthorize(_ platformType:RJLoginInPlatformType, _ settings:[AnyHashable:Any]!,_ authorizeStateHandler: AuthorizeStateChangedHandler? ) -> Void {
        
        let callBack = {(_ state:String,_ userInfo:[AnyHashable:Any]?,_ errorInfo:Error?) in
            guard let authorizeState = RJMobShareAuthorizeState(rawValue: state) else { return  }
            guard let coluse = authorizeStateHandler else { return  }
            coluse(authorizeState,userInfo,errorInfo)
        }
        let params : [AnyHashable:Any] = [
            "platformType"  :platformType.rawValue,
            "settings"      :settings,
            "onStateChanged":callBack
        ]
        CTMediator().performTarget("Mob", action: "Authorize", params: params, shouldCacheTarget: true)
        
    }
    class func mobGetVerifyCode(_ methodType:RJMobGetVefifyCodeMethod ,_ phoneNumber: String ,_ zone: String ,_ template: String , _ handler: GetVerifyCodeHandler?) -> Void {
        let params = ["methodType" :methodType.rawValue,
                      "phoneNumber":phoneNumber,
                      "zone"       :zone,
                      "template"   :template,
                      "handler":handler ?? ""] as [String : Any]
        CTMediator().performTarget("Mob", action: "GetVerifyCode", params: params, shouldCacheTarget: true)
    }
    //MARK: - Networking
    private class func reuqest( _ params:[AnyHashable:Any]) ->  Void {
        CTMediator().performTarget("Network", action: "Request", params: params, shouldCacheTarget: true)
    }
    class func registerByPhone( _ account:String? , _ password:String? , _ passwordVerify:String?,_ callBack:NetworkHandler?) -> Void{
        let helper = RJLoginHelper()
        helper.account = account
        helper.password = password
        helper.passwordVerify = passwordVerify
        let params = helper.argument(.RegisterByPhone, callBack: callBack)
        reuqest(params)
    }
    class func registerByEmail( _ account:String? , _ password:String? ,_ callBack:NetworkHandler?) -> Void{
        let helper = RJLoginHelper()
        helper.account = account
        helper.password = password
        let params = helper.argument(.RegisterByEmail, callBack: callBack)
        reuqest(params)
    }
    class func LoginByAccount( _ account:String? , _ password:String?, _ callBack:NetworkHandler?) -> Void {
        let helper = RJLoginHelper()
        helper.account = account
        helper.password = password
        let params = helper.argument(.LoginByAccount, callBack: callBack)
        reuqest(params)
    }
    class func QuickLoginByPhone( _ account:String? , _ password:String?, _ callBack:NetworkHandler?) -> Void {
        let helper = RJLoginHelper()
        helper.account = account
        helper.password = password
        let params = helper.argument(.QuickLoginByPhone, callBack: callBack)
        CTMediator().performTarget("Network", action: "Request", params: params, shouldCacheTarget: true)
    }
    class func ThirdPlatformLogin( _ openId:String? ,_ token:String?, _ type:RJLoginInPlatformType, _ callBack:NetworkHandler?) -> Void {
        let helper = RJLoginHelper()
        helper.openId = openId
        helper.thirdPlatformType = type
        let params = helper.argument(.ThirdPlatformLogin, callBack: callBack)
        reuqest(params)
    }
    class func resetPasswordByPhone(_ phoneNumber:String? ,_ password:String? , _ verifyCode:String? , _ callBack:NetworkHandler?) -> Void {
        let helper = RJLoginHelper()
        helper.phoneNumber   = phoneNumber
        helper.password      = password
        helper.verifyCode    = verifyCode
        let params = helper.argument(.ResetPasswordByPhone, callBack: callBack)
        reuqest(params)
    }
    class func resetPasswordByEmail(_ email:String?, _ callBack:NetworkHandler?) -> Void {
        let helper = RJLoginHelper()
        helper.email   = email
        let params = helper.argument(.ResetPasswordByEmail, callBack: callBack)
        reuqest(params)
    }
    class func savePersonInfo() -> Void {
        let helper = RJLoginHelper()
        let params = helper.argument(.SavePersonInfo, callBack: nil)
        reuqest(params)
    }
    private func argument(_ apiType:LoginAPIType , callBack: NetworkHandler?) -> [AnyHashable:Any] {
        switch apiType {
        case .RegisterByPhone:
            return  [ "apiType"  : LoginAPIType.RegisterByPhone.rawValue,
                      "arguments": ["zone"         :"86",
                                    "systemVersion":"IOS",
                                    "phone"        :account ?? "",
                                    "code"         :password ?? "",
                                    "pwd"          :passwordVerify ?? "",
                                    "oemType"      :"KU",
                                    "sdkVersion"   :kAPPVersionForMobSDK,
                                    "appVersion"   :kAPPVersionForNetWork],
                      "callBack" : callBack ?? ""]
        case .RegisterByEmail:
            return  [ "apiType"  : LoginAPIType.RegisterByEmail.rawValue,
                      "arguments": ["useraccount"  :account ?? "",
                                    "pwd"         :password ?? ""],
                      "callBack" : callBack ?? ""]
        case .LoginByAccount :
            let type = RJAPPModel.currentLanguage() == .SimpleChinese ? "0":"1"
            return  ["apiType"  : LoginAPIType.LoginByAccount.rawValue,
                     "arguments": ["account"       :account ?? "",
                                   "pwd"           :password ?? "",
                                   "type"          :type],
                     "callBack" : callBack ?? ""]
        case .QuickLoginByPhone :
            return  [ "apiType"  : LoginAPIType.QuickLoginByPhone.rawValue,
                      "arguments": ["zone"         :"86",
                                    "systemVersion":"IOS",
                                    "phone"        :account ?? "",
                                    "code"         :password ?? "",
                                    "oemType"      :"KU",
                                    "sdkVersion"   :kAPPVersionForMobSDK,
                                    "appVersion"   :kAPPVersionForNetWork],
                      "callBack" : callBack ?? ""]
        case .ThirdPlatformLogin :
            var platform = ""
            switch thirdPlatformType{
            case .QQ:
                platform = "1"
            case .wechat:
                platform = "2"
            case .facebook:
                platform = "5"
            case .twitter:
                platform = "6"
            default:
                break
            }
            return  [ "apiType"  : LoginAPIType.ThirdPlatformLogin.rawValue,
                      "arguments": ["openId"       :openId ?? "",
                                    "token"        :token ?? "",
                                    "type"         :platform,
                                    "systemVersion":"IOS",
                                    "oemType"      :"KU",
                                    "appVersion"   :kAPPVersionForNetWork,
                                    "inviteCode"   :""],
                      "callBack" : callBack ?? ""]
        case .ResetPasswordByPhone :
            return  [ "apiType"  : LoginAPIType.ResetPasswordByPhone.rawValue,
                      "arguments": ["zone"         :"86",
                                    "phone"        :phoneNumber ?? "",
                                    "pwd"          :password ?? "",
                                    "code"         :verifyCode ?? "",
                                    "oemType"      :"KU",
                                    "sdkVersion"   :kAPPVersionForMobSDK],
                      "callBack" : callBack ?? ""]
        case .ResetPasswordByEmail :
            return  [ "apiType"  : LoginAPIType.ResetPasswordByEmail.rawValue,
                      "arguments": ["email"         :email],
                      "callBack" : callBack ?? ""]
            
        case .SavePersonInfo :
            return  [ "apiType"  : LoginAPIType.ResetPasswordByEmail.rawValue,
                      "arguments": ["email"         :email],
                      "callBack" : callBack ?? ""]
        default:
            return ["":""]
        }
    }
    class func emailCheck(_ email:String?) -> Bool {
        let emailRegex  = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailVerify = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailVerify.evaluate(with: email)
    }
    class func phoneNumberCheck(_ email:String?) -> Bool {
        let phoneNumRegex  = "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199|(147))\\d{8}$"
        let phoneNumVerify = NSPredicate(format: "SELF MATCHES %@", phoneNumRegex)
        return phoneNumVerify.evaluate(with: email)
    }
    
    
    
}
