//
//  RJNetError.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/16.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
enum RJNetErrorType :Int{
    case success                               = 0       // 请求成功
    case networkingError                       = -99999  // 没有网络
    case other                                 = -95     // 未知错误
}
class RJNetError: NSError {
    
    class
        func requsetState(_ retStr:String?) -> Bool {
        let errorType = RJNetError.netErrorTypeWithRet(retStr)
        switch errorType {
        case .success:
            return true
        default:
            return false
        }
    }
    class
    func requsetState(_ errorType:RJNetErrorType) -> Bool {
        switch errorType {
        case .success:
            return true
        default:
            return false
        }
    }
    class
        func netErrorTypeWithRet(_ retStr:String?) -> RJNetErrorType {
        guard let errorType = retStr                             else { return .other }
        guard let errorInt  = Int(errorType)                     else { return .other }
        guard let type      = RJNetErrorType(rawValue: errorInt) else { return .other }
        return type
    }
    class
        func netError(_ retStr:String?) -> RJNetError {
        let errorType = RJNetError.netErrorTypeWithRet(retStr)
        switch errorType {
        case .networkingError:
            return RJNetError(domain: "Networking Error", code: RJNetErrorType.networkingError.rawValue)
        default:
            return RJNetError(domain: "Networking Error", code: RJNetErrorType.networkingError.rawValue)
        }
        
    }
    class
    func netError(_ errorType:RJNetErrorType) -> RJNetError {
        switch errorType {
        case .networkingError:
            return RJNetError(domain: "Networking Error", code: RJNetErrorType.networkingError.rawValue)
        default:
            break
        }
        return RJNetError(domain: "Networking Error", code: RJNetErrorType.networkingError.rawValue)
    }
}
