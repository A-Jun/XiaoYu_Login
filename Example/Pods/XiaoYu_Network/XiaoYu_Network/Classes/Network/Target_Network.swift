//
//  Target_Network.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/17.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
typealias NetCallback = (_ success:Bool ,_ result:Any? , _ error:NSError?)->Void
@objc(Target_Network)
class Target_Network: NSObject {
    var arguments : [AnyHashable : Any]?
    var callBack  : NetCallback?
    var APIType   : RJAPIType = .none
    
    
    
     /// 网络配置
    @objc func Action_Configure(params:[AnyHashable:Any]!) -> Void {
        RJNeworkingManager.shareInstance.configure()
    }
    @objc func Action_Request(params:[AnyHashable:Any]!) -> Void {
        parseArgument(params)
    }
    private
    func parseArgument(_ params:[AnyHashable:Any]!) -> Void {
        let api   =  params["apiType"]         as? String
        guard let type = api else { return  }
        guard let apiType = RJAPIType(rawValue: type) else { return  }
        APIType   = apiType
        arguments = params["arguments"]       as? [AnyHashable : Any]
        callBack  = params["callBack"]        as? (_ success:Bool ,_ result:Any? , _ error:NSError?)->Void
        RJNeworkingManager.shareInstance.request(RJRequset.requsetWith(APIType, params: arguments), callBack)
    }
}
