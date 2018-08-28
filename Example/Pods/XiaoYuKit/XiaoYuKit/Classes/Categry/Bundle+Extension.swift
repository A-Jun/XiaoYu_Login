//
//  uiu.swift
//  Pods-XiaoYuKit_Example
//
//  Created by RJ on 2018/8/27.
//

import UIKit

public extension Bundle{
    public class func localizedString(forKey:String , value :String?,table:String?,targetClass:AnyClass) -> String {
        
        
        guard var langue = NSLocale.preferredLanguages.first else { return forKey }
        if langue.contains("zh-Hans") {
            langue = "zh-Hans"
        }else if langue.contains("id") {
            langue = "id"
        }else{
            langue = "en"
        }
        let curBundle = Bundle(for: targetClass )
        guard let infoDictionary =  curBundle.infoDictionary else { return forKey }
        guard let bundleName = infoDictionary[(kCFBundleNameKey as String )] else { return forKey }
        let curBundleName = bundleName as! String
        guard let path = curBundle.path(forResource: curBundleName , ofType: ".bundle") else { return forKey }
        guard let bundle = Bundle(path: path) else { return forKey }
        guard let path1  = bundle.path(forResource: langue, ofType: ".lproj") else { return forKey }
        guard let bundle1 = Bundle(path: path1) else { return forKey }
        let value = bundle1.localizedString(forKey: forKey, value:value, table:table)
        return value
        
    }
}
