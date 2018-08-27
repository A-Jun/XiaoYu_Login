//
//  RJTexTfr.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/13.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit

class RJTextField: UIView ,UITextFieldDelegate{
    let tap  =  UITapGestureRecognizer()
    var maxLength  : Int = 20
    
    var isSecureTextEntry : Bool {
        set(isSecureTextEntry){
           inputTF.isSecureTextEntry = isSecureTextEntry
        }
        get{
            return inputTF.isSecureTextEntry
        }
    }
    var text : String? {
        set(text){
            inputTF.text = text
        }
        get{
            return inputTF.text
        }
    }
    var keyboardType : UIKeyboardType {
        set(keyboardType){
            inputTF.keyboardType = keyboardType
        }
        get{
            return inputTF.keyboardType
        }
    }
    var placeholder :String?{
        set(placeholder){
            inputTF.placeholder = placeholder
        }
        get{
            return inputTF.placeholder
        }
    }
    
    var attributedPlaceholder : NSAttributedString? {
        set(attributedPlaceholder){
            inputTF.attributedPlaceholder = attributedPlaceholder
        }
        get{
            return inputTF.attributedPlaceholder
        }
    }
    
    private
    lazy var logoBtn : UIButton = {
        let btn              = UIButton.init(type: .custom)
        btn.backgroundColor  = .clear
        btn.titleLabel?.font = RJFontMedium(15)
        btn.setTitleColor(grayTextColor, for: .normal)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    private
    lazy var inputTF: UITextField = {
        let textField = UITextField()
        textField.delegate  = self
        textField.font = RJFontMedium(15)
        textField.textColor = grayTextColor
        textField.tintColor = .white
        return textField
    }()
    private
    lazy var functionBtn : UIButton = {
        let btn              = UIButton.init(type: .custom)
        btn.backgroundColor  = .clear
        btn.titleLabel?.font = RJFontMedium(10)
        btn.setTitleColor(grayTextColor, for: .normal)
        return btn
    }()
    private
    lazy var splitLine: UIView = {
        let line = UIView()
        line.backgroundColor = splitColor
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        configureUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private
    func configureUI() -> Void {
        addSubview(logoBtn)
        addSubview(inputTF)
        addSubview(functionBtn)
        addSubview(splitLine)
        registNotification()
    }
    func configureLayout() -> Void {
        
        logoBtn.snp.makeConstraints{
            $0.left.equalToSuperview().offset(kAutoWid(21))
            $0.centerY.equalToSuperview()
            $0.width.equalTo(logoBtn.size)
        }
        inputTF.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(logoBtn.snp.right).offset(kAutoWid(15))
            $0.right.equalTo(functionBtn.snp.left).offset(kAutoWid(-15))
        }
        
        functionBtn.snp.makeConstraints{
            $0.right.equalToSuperview().offset(kAutoWid(-21))
            $0.centerY.equalToSuperview()
            $0.width.equalTo(functionBtn.size)
        }
        splitLine.snp.makeConstraints{
            $0.left.equalToSuperview().offset(kAutoWid(21))
            $0.right.equalToSuperview().offset(kAutoWid(-21))
            $0.bottom.equalToSuperview().offset(kAutoHei(-1))
            $0.height.equalTo(kAutoHei(1))
        }
    }
    //MARK: Notification
    private
    func registNotification() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange), name: Notification.Name.UITextFieldTextDidChange, object: inputTF)
    }
    private
    func removeNotification() -> Void {
        NotificationCenter.default.removeObserver(self)
    }
    @objc
    private
    func textFieldTextDidChange(_ notification:Notification) -> Void {
        let textField  = notification.object as! UITextField
        guard let toBeString = textField.text else { return  }
        if  toBeString.count > maxLength {
            inputTF.text = toBeString.substring(to: toBeString.index(toBeString.startIndex, offsetBy: maxLength))
        }
        
    }
    func setLogoBtn(image:UIImage? = nil , title:String? = nil,  state : UIControlState = .normal) -> Void {
        
        logoBtn.setImage(image, for: state)
        logoBtn.setTitle(title, for: state)
        logoBtn.sizeToFit()
    }
    func setFunctionBtn( image:UIImage? = nil , title:String? = nil,  state : UIControlState = .normal) -> Void {
        
        functionBtn.setImage(image, for: state)
        functionBtn.setTitle(title, for: state)
        functionBtn.sizeToFit()
    }
    func addTargetForLogoBtn(_ target:Any? ,anction:Selector,enent:UIControlEvents) -> Void {
        logoBtn.isUserInteractionEnabled = true
        logoBtn.addTarget(target, action: anction, for: enent)
    }
    func addTargetForFunctionBtn(_ target:Any? ,anction:Selector,enent:UIControlEvents) -> Void {
        functionBtn.addTarget(target, action: anction, for: enent)
    }
    func creatCornerForFunctionBtn() -> Void {
        functionBtn.sizeToFit()
        functionBtn.cornerCutWith(functionBtn.height / 2.0, 1.0, splitColor)
    }
    //MARK: - UITextFieldDelegate
    internal
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        addTapViewForResignFirstResponder()
        return true
    }
    private
    func addTapViewForResignFirstResponder() -> Void {
        tap.addTarget(self, action: #selector(clickTapView))
        self.superview?.superview?.addGestureRecognizer(tap)
        
    }
   
    deinit {
        self.superview?.superview?.removeGestureRecognizer(tap)
    }
    //MARK: - Event Responce
    @objc
    private
    func clickTapView() -> Void {
        inputTF.resignFirstResponder()
    }
}
