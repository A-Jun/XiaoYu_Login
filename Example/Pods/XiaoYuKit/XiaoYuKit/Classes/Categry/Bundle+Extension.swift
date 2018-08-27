//
//  uiu.swift
//  Pods-XiaoYuKit_Example
//
//  Created by RJ on 2018/8/27.
//

import UIKit

public extension Bundle{
    public class func localizedString(forKey:String , value :String?,table:String?,targetClass:AnyClass?) -> String {
        guard let Class = targetClass else { return forKey }
        guard var langue = NSLocale.preferredLanguages.first else { return forKey }
        if langue.contains("zh-Hans") {
            langue = "zh-Hans"
        }else if langue.contains("id") {
            langue = "id"
        }else{
            langue = "en"
        }
        let bundle = Bundle(path: Bundle(for: Class.self).path(forResource: langue , ofType: ".lproj")!)
        let value = bundle!.localizedString(forKey: forKey, value:value, table:table)
        return value
        
    }
}
