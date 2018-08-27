//
//  RJRequset.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/16.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
import YTKNetwork
enum RJAPIType :String{
    case none
    // ---------------------------------Login---------------------------------
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
    
}
class RJRequset: YTKBaseRequest {
    var apiType : RJAPIType = .none
    var arguments : [AnyHashable:Any]?
    
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
    override func requestUrl() -> String {
        return requestString(apiType)
    }
    override func requestArgument() -> Any? {
        return arguments ?? nil
    }
    class
    func requsetWith(_ apiType:RJAPIType , params:[AnyHashable:Any]?) -> RJRequset {
        let request = RJRequset()
        request.apiType   = apiType
        request.arguments = params
        return request
    }
    func requestString(_ apiType:RJAPIType) -> String {
        switch apiType {
        case .none:
            break
        case .PhoneRegistered:
            return "/BadmintonLoginController/checkPhoneRegistered"
        case .RegisterByPhone:
            return "/BadmintonLoginController/phoneVerify"
        case .RegisterByEmail:
            return "/BadmintonLoginController/emailRegister"
        case .LoginByAccount:
            return "/BadmintonLoginController/accountLogin"
        case .QuickLoginByPhone:
            return "/BadmintonLoginController/phoneVerify"
        case .ThirdPlatformLogin:
            return "/BadmintonLoginController/qqLoginCallBack"
        case .GetVerifyCodeByPhone:
            return "/BadmintonLoginController/getPwdByPhoneCode"
        case .ResetPasswordByPhone:
            return "/BadmintonLoginController/registerPwd"
        case .ResetPasswordByEmail:
            return "/BadmintonLoginController/getMyEmailCode"
        case .ModifyPassword:
            return "/BadmintonLoginController/changePwd"
        case .BindThirdPlatform:
            return "/BadmintonLoginController/bindQQorWX"
        case .BindPhone:
            return "/BadmintonLoginController/bindPhone"
        case .GetAccountBindInfo:
            return "/BadmintonLoginController/getMyAccount"
        case .RelieveBind:
            return "/BadmintonLoginController/unbind"
        }
        return "1"
    }
}
