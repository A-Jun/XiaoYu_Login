//
//  RJRJInformationWebVM.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/11.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
enum WebViewState :Int {
    case start
    case finish
    case fail
}
class RJWebDelegate: NSObject ,UIWebViewDelegate{
    var stateClosure : ((_ state:WebViewState)->Void)?
    
    private override init() {
        super.init()
    }
    convenience init(WebViewStateChange closure:@escaping (_ state:WebViewState)->Void){
        self.init()
        stateClosure = closure
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        guard let closure = stateClosure else { return  }
        closure(.start)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard let closure = stateClosure else { return  }
        closure(.finish)
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        guard let closure = stateClosure else { return  }
        closure(.fail)
    }
}
