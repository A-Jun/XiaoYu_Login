//
//  RJPrivacyWebViewController.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/11.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
enum WebType : Int{
    case SportGuideDetail
    case BannerDetail
    case TopicList
}
class RJInformationWebViewController: RJBaseViewController {
    var infomationUrl :String?
    var titleString   :String?
    var webViewDelegate :RJWebDelegate?
    
    private
    lazy var webView: UIWebView = {
        let web = UIWebView()
        webViewDelegate = RJWebDelegate(WebViewStateChange: {
            if $0 == .start {
                self.indicator.startAnimating()
            }else{
                self.indicator.stopAnimating()
            }
        })
        web.delegate = webViewDelegate
        return web
    }()
    private
    lazy var indicator: UIActivityIndicatorView = {
        let ind = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        ind.color = .black
        return ind
    }()
    
    
    
    
    //MARK: - ViewControllerLifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        view.addSubview(webView)
        view.addSubview(indicator)
        showInfomationWebView()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView.snp.makeConstraints{
            $0.top.left.right.bottom.equalToSuperview()
        }
        indicator.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
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
        navBarTitle(titleString)
    }
    func showInfomationWebView() -> Void {
        guard let urlString = infomationUrl else { return }
        let url = URL(string: urlString)
        guard let url_G = url else { return  }
        var request = URLRequest(url: url_G)
        request.httpShouldHandleCookies = false
        webView.loadRequest(request)
        
    }
    //MARK: - Event Responce
    @objc
    private
    func left_firstNavitemBtnClick() -> Void {
        exitViewController()
    }
}
