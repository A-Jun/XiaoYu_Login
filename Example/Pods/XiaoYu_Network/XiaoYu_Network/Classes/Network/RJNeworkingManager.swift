//
//  RJNeworkingManager.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/16.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
import YTKNetwork
typealias RJNeworkingCallBack = (_ success:Bool , _ result:Any? ,_ error:RJNetError? )->Void
//是否旧版本
let isOldVersion = false
let kBaseUrl = isOldVersion ? "http://mlf.f3322.net:83" : "http://appserv.coollang.com"

class RJNeworkingManager: NSObject {
    static let shareInstance = RJNeworkingManager()
    func configure() -> Void {
        let config = YTKNetworkConfig.shared()
        config.baseUrl = kBaseUrl
        YTKNetworkAgent.shared().setValue(NSSet(objects: "application/json",
                                                        "text/html",
                                                        "text/plain",
                                                        "text/javascript",
                                                        "image/jpeg",
                                                        "image/png",
                                                        "application/octet-stream",
                                                        "text/json"),
                                          forKeyPath: "jsonResponseSerializer.acceptableContentTypes")
        
    }
   
    func request(_ api:RJRequset , _ callBack: RJNeworkingCallBack?) -> Void {
        print("\(String(describing: api.arguments))")
        guard let coluse = callBack else { return  }
        api.startWithCompletionBlock(success: {
            let responceResult       = $0.responseObject ?? ["ret"    :"",
                                                             "errDesc":""]
            let result               = responceResult    as! [AnyHashable : Any]
            let ret                  = result["ret"]     as! String
            let errDesc              = result["errDesc"]
            coluse(RJNetError.requsetState(ret),errDesc,RJNetError.netError(ret))
        }) {
            let responceResult       = $0.responseObject ?? ["ret"    :"",
                                                             "errDesc":""]
            let result               = responceResult    as! [AnyHashable : Any]
            let ret                  = result["ret"]     as! String
            let errDesc              = result["errDesc"] 
            coluse(false,errDesc,RJNetError.netError(ret))
        }
    }
}
