//
//  RJPickerDataSource.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/23.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
typealias RJPickerViewSelectedValue = ( _ type:FillInInformation,_ value:Int) -> Void
class RJPersonalInformationPickerDataSource: NSObject ,UIPickerViewDelegate,UIPickerViewDataSource{
    var type :FillInInformation = .Height
    
    var selectedRow :RJPickerViewSelectedValue?
    var rowHeight : CGFloat = kAutoHei(30)
    lazy var dataSource: [Int] = {
        var array = [Int]()
        if type == .Height {
            for index in 50 ... 220 {
                array.append(index)
            }
        }else{
            for index in 0 ... 178 {
                array.append(index)
            }
        }
        
        return array
    }()
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(dataSource[row])
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label   = UILabel()
        let text = String(dataSource[row])
        label.text = text
        label.textColor = grayTextColor
        label.font      = RJFontMedium(19)
        label.textAlignment = .center
        if type == .Weight {
            label.transform = CGAffineTransform(rotationAngle: .pi / 2.0)
        }
        return label
        
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let selectedValue = selectedRow else { return  }
        selectedValue(type,dataSource[row])
    }
}
