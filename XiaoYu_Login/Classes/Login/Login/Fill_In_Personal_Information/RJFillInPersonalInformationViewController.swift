//
//  RJFillInPersonalInfomationViewController.swift
//  XiaoYu_V3.0_Refactor
//
//  Created by RJ on 2018/8/22.
//  Copyright © 2018年 coollang. All rights reserved.
//

import UIKit
enum FillInInformation {
    case Hander
    case Gender
    case Height
    case Weight
    case NameAndIcon
}
class RJFillInPersonalInformationViewController: RJBaseViewController {
    var type           :FillInInformation = .Hander
    
    private
    lazy var notice : UILabel = {
        let label = UILabel()
        label.textColor = grayTextColor
        label.font      = RJFontBold(19)
        label.numberOfLines = 0;
        label.textAlignment = .center
        return label
    }()
    private
    lazy var handerView: UIView = {
        let hander = UIView()
        hander.addSubview(leftHand)
        hander.addSubview(rightHand)
        leftHand.snp.makeConstraints{
            $0.size.equalTo(CGSize(width: kAutoWid(110), height: kAutoWid(110)))
            $0.top.left.bottom.equalToSuperview()
            $0.right.equalTo(rightHand.snp.left).offset(kAutoWid(-63))
        }
        rightHand.snp.makeConstraints{
            $0.size.equalTo(CGSize(width: kAutoWid(110), height: kAutoWid(110)))
            $0.top.right.bottom.equalToSuperview()
        }
        return hander
    }()
    private
    lazy var leftHand : RJButton = {
        let btn              = RJButton.init(type: .custom)
        btn.backgroundColor  = .clear
        btn.tagName          = .leftHand
        btn.setImage(UIImage.currentBoudle("login_left_hand_icon", RJLoginHelper.self), for: .normal)
        btn.addTarget(self, action: #selector(nextBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    private
    lazy var rightHand : RJButton = {
        let btn              = RJButton.init(type: .custom)
        btn.backgroundColor  = .clear
        btn.tagName          = .rightHand
        btn.setImage(UIImage.currentBoudle("login_right_hand_icon", RJLoginHelper.self), for: .normal)
        btn.addTarget(self, action: #selector(nextBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    private
    lazy var genderView: UIView = {
        let gender = UIView()
        gender.addSubview(boy_head)
        gender.addSubview(girl_head)
        boy_head.snp.makeConstraints{
            $0.size.equalTo(CGSize(width: kAutoWid(110), height: kAutoWid(110)))
            $0.top.left.right.equalToSuperview()
        }
        girl_head.snp.makeConstraints{
            $0.top.equalTo(boy_head.snp.bottom).offset(kAutoHei(70))
            $0.size.equalTo(CGSize(width: kAutoWid(110), height: kAutoWid(110)))
            $0.bottom.right.left.equalToSuperview()
        }
        return gender
    }()
    private
    lazy var boy_head : RJButton = {
        let btn              = RJButton.init(type: .custom)
        btn.backgroundColor  = .clear
        btn.tagName          = .male
        btn.setImage(UIImage.currentBoudle("login_boy_head_icon", RJLoginHelper.self), for: .normal)
        btn.addTarget(self, action: #selector(nextBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    private
    lazy var girl_head : RJButton = {
        let btn              = RJButton.init(type: .custom)
        btn.backgroundColor  = .clear
        btn.tagName          = .female
        btn.setImage(UIImage.currentBoudle("login_girl_head_icon", RJLoginHelper.self), for: .normal)
        btn.addTarget(self, action: #selector(nextBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    private
    lazy var heightView: UIView = {
        let height = UIView()
        height.addSubview(boy_body)
        height.addSubview(picker)
        height.addSubview(picker_dial)
        height.addSubview(picker_unit)
        boy_body.snp.makeConstraints{
            $0.size.equalTo(CGSize(width: kAutoWid(115), height: kAutoHei(223)))
            $0.top.left.bottom.equalToSuperview()
            $0.right.equalTo(picker.snp.left).offset(kAutoWid(-30))
        }
        picker.snp.makeConstraints{
            $0.size.equalTo(CGSize(width: kAutoWid(91), height: kAutoHei(223)))
            $0.bottom.right.top.equalToSuperview()
        }
        picker_dial.snp.makeConstraints{
            $0.left.top.bottom.equalTo(picker)
            $0.width.equalTo(kAutoWid(10))
        }
        picker_unit.snp.makeConstraints{
            $0.right.centerY.equalTo(picker)
        }
        return height
    }()
    private
    lazy var boy_body : UIImageView = {
        let imageView   = UIImageView()
        let imageString = RJPersonInformationModel.sharePerson.gender ? "login_boy_body_icon":"login_girl_body_icon"
        imageView.image = UIImage.currentBoudle(imageString, RJLoginHelper.self)
        return imageView
    }()
    private
    lazy var picker_dial : UIImageView = {
        let imageView   = UIImageView()
        let imageString = type == .Height ? "login_height_dials":"login_weight_dials"
        imageView.image = UIImage.currentBoudle(imageString, RJLoginHelper.self)
        return imageView
    }()
    private
    lazy var picker_unit : UILabel = {
        let label   = UILabel()
        let text = type == .Height ? "cm":"Kg"
        label.text = text
        label.textColor = grayTextColor
        label.font      = RJFontMedium(10)
        label.textAlignment = .center
        return label
    }()
    private
    let pickerDataSource = RJPersonalInformationPickerDataSource()
    private
    lazy var picker : UIPickerView = {
        let picker         = UIPickerView()
        pickerDataSource.type = type
        picker.delegate    = pickerDataSource
        picker.dataSource  = pickerDataSource
        picker.tintColor   = .clear
        pickerDataSource.selectedRow = { (selectedType:FillInInformation,value:Int) in
            if selectedType == .Height {
                RJPersonInformationModel.sharePerson.height = value
            }else{
                RJPersonInformationModel.sharePerson.weight = value
            }
            
        }
        var row = 0
        if type == .Height {
            pickerDataSource.rowHeight = kAutoHei(30)
            row = RJPersonInformationModel.sharePerson.gender ? 120 : 110
        }else{
            pickerDataSource.rowHeight = kAutoWid(40)
            row = RJPersonInformationModel.sharePerson.gender ? 70 : 50
        }
        picker.selectRow(row, inComponent: 0, animated: false)
        return picker
    }()
    private
    lazy var weightView: UIView = {
        let weight = UIView()
        weight.addSubview(boy_body)
        weight.addSubview(picker)
        picker.frame = CGRect(x: kAutoWid(30), y: kAutoHei(-62), width: kAutoHei(71), height: kAutoWid(315))
        picker.transform = CGAffineTransform(rotationAngle: -.pi / 2.0)
        picker.x = kAutoWid(0)
        picker.y = kAutoHei(230)
        weight.addSubview(picker_dial)
        weight.addSubview(picker_unit)
        boy_body.snp.makeConstraints{
            $0.size.equalTo(CGSize(width: kAutoWid(115), height: kAutoHei(223)))
            $0.top.centerX.equalToSuperview()
        }
        picker_dial.snp.makeConstraints{
            $0.top.equalTo(boy_body.snp.bottom).offset(kAutoHei(8))
            $0.left.right.equalToSuperview()
            $0.height.equalTo(kAutoHei(10))
        }
        picker_unit.snp.makeConstraints{
            $0.bottom.centerX.equalToSuperview()
        }
        return weight
    }()
    private
    lazy var foreOrBackView : UIView = {
        let foreOrBack = UIView()
        foreOrBack.addSubview(fore)
        foreOrBack.addSubview(foreOrBackSplit)
        foreOrBack.addSubview(back)
        fore.snp.makeConstraints{
            $0.top.bottom.right.equalToSuperview()
            $0.size.equalTo(CGSize(width: kAutoWid(167.5), height: kAutoHei(41)))
            $0.left.equalTo(foreOrBackSplit.snp.right)
        }
        foreOrBackSplit.snp.makeConstraints{
            $0.size.equalTo(CGSize(width: kAutoWid(1), height: kAutoHei(41)))
            $0.top.centerX.centerY.bottom.equalToSuperview()
        }
        back.snp.makeConstraints{
            $0.top.bottom.left.equalToSuperview()
            $0.size.equalTo(CGSize(width: kAutoWid(167.5), height: kAutoHei(41)))
            $0.right.equalTo(foreOrBackSplit.snp.left)
        }
        return foreOrBack
    }()
    private
    lazy var fore : UIView = {
        let btn              = RJButton.init(type: .custom)
        btn.backgroundColor  = .clear
        btn.titleLabel?.font = RJFontMedium(15)
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(loginBtnUnableColor, for: .normal)
        btn.addTarget(self, action: #selector(nextBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    private
    lazy var foreOrBackSplit : UIView = {
        let foreOrBackSplit = UIView()
        foreOrBackSplit.backgroundColor = splitColor
        return foreOrBackSplit
    }()
    private
    lazy var back : UIView = {
        let btn              = RJButton.init(type: .custom)
        btn.backgroundColor  = .clear
        btn.titleLabel?.font = RJFontMedium(15)
        btn.setTitle("Last", for: .normal)
        btn.setTitleColor(loginBtnUnableColor, for: .normal)
        btn.addTarget(self, action: #selector(LastBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    private
    lazy var nameAndIconView: UIView = {
        let nameAndIcon = UIView()
        nameAndIcon.addSubview(icon)
        name.configureLayout()
        nameAndIcon.addSubview(name)
        nameAndIcon.addSubview(complete)
        icon.snp.makeConstraints{
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: kAutoWid(111), height: kAutoWid(111)))
        }
        name.snp.makeConstraints{
            $0.top.equalTo(icon.snp.bottom).offset(kAutoHei(32))
            $0.left.centerX.right.equalToSuperview()
            $0.height.equalTo(kAutoHei(41))
        }
        complete.snp.makeConstraints{
            $0.top.equalTo(name.snp.bottom).offset(kAutoHei(32))
            $0.left.equalToSuperview().offset(kAutoWid(21))
            $0.right.equalToSuperview().offset(kAutoWid(-21))
            $0.height.equalTo(kAutoHei(41))
            $0.bottom.equalToSuperview()
        }
        return nameAndIcon
    }()
    private
    lazy var icon : RJButton = {
        let btn              = RJButton.init(type: .custom)
        btn.backgroundColor  = .clear
        btn.setImage(UIImage.currentBoudle("login_default_avatar", RJLoginHelper.self), for: .normal)
        btn.addTarget(self, action: #selector(iconBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    private
    lazy var name : RJTextField = {
        let textfield  = RJTextField()
        textfield.backgroundColor   = UIColor.init(0xffffff, 0.05)
        textfield.placeholder       = "UserName"
        return textfield
    }()
    private
    var changeStateTimer:Timer?
    private
    lazy var complete : RJButton = {
        let btn              = RJButton.init(type: .custom)
        btn.backgroundColor  = .clear
        btn.titleLabel?.font = RJFontMedium(15)
        btn.setTitle("Complete", for: .normal)
        btn.setTitleColor(loginBtnUnableColor, for: .normal)
        btn.addTarget(self, action: #selector(completeBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    //MARK: - ViewControllerLifeCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        foreOrBackView.cornerCutWith(kAutoHei(20.5), 1, splitColor)
        complete.cornerCutWith(kAutoHei(20.5), 1, splitColor)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if type != .NameAndIcon {
            navBarHidden = true
        }else{
            
            navigationController?.navigationBar.barTintColor = VCBackGorundColor
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navBarHidden = false
    }
    private
    func configureUI() -> Void {
        addSubview(notice)
        notice.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(kAutoHei(60))
            $0.width.equalTo(kAutoWid(300))
            $0.centerX.equalToSuperview()
        }
        switch type {
        case .Hander:
            configureUIForHanderType()
        case .Gender:
            configureUIForGenderType()
        case .Height:
            configureUIForHeightType()
        case .Weight:
            configureUIForWeightType()
        case .NameAndIcon:
            configureUIForNameAndIconType()
        }
    }
    //MARK: - Event Reponce
    @objc
    private
    func LastBtnClick(_ button:RJButton) -> Void {
        switch type {
        case .Height:
            navigationController?.popToRootViewController(animated: true)
        case .Weight:
            navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    @objc
    private
    func nextBtnClick(_ button:RJButton) -> Void {
        switch type {
        case .Hander:
            RJPersonInformationModel.sharePerson.hander = button.tagName == .leftHand ? false : true
            let fillIn = RJFillInPersonalInformationViewController()
            fillIn.type = .Gender
            navigationController?.pushViewController(fillIn, animated: true)
        case .Gender:
            RJPersonInformationModel.sharePerson.gender = button.tagName == .female ? false : true
            let fillIn = RJFillInPersonalInformationViewController()
            fillIn.type = .Height
            navigationController?.pushViewController(fillIn, animated: true)
        case .Height:
            let fillIn = RJFillInPersonalInformationViewController()
            fillIn.type = .Weight
            navigationController?.pushViewController(fillIn, animated: true)
        case .Weight:
            let fillIn = RJFillInPersonalInformationViewController()
            fillIn.type = .NameAndIcon
            navigationController?.pushViewController(fillIn, animated: true)
        case .NameAndIcon:
            print("完成")
        }
    }
  
    
   
    
}
//MARK: - 左右手
extension RJFillInPersonalInformationViewController{
    private
    func configureUIForHanderType() -> Void {
        notice.text = LoginLocation("Tell us your habit hand,it can be more accurately identify your swing data")
        addSubview(handerView)
        handerView.snp.makeConstraints {
            $0.top.equalTo(notice.snp.bottom).offset(kAutoHei(110))
            $0.centerX.equalToSuperview()
        }
    }
}

//MARK: - 性别
extension RJFillInPersonalInformationViewController{
    private
    func configureUIForGenderType() -> Void {
        notice.text = LoginLocation("We will use your health infomation to give you a more accurate motion data")
        addSubview(genderView)
        genderView.snp.makeConstraints {
            $0.top.equalTo(notice.snp.bottom).offset(kAutoHei(70))
            $0.centerX.equalToSuperview()
        }
    }
}

//MARK: - 身高
extension RJFillInPersonalInformationViewController{
    private
    func configureUIForHeightType() -> Void {
        notice.text = LoginLocation("We will use your health infomation to give you a more accurate motion data")
        addSubview(heightView)
        addSubview(foreOrBackView)
        foreOrBackView.sizeToFit()
        heightView.snp.makeConstraints {
            $0.top.equalTo(notice.snp.bottom).offset(kAutoHei(70))
            $0.centerX.equalToSuperview()
        }
        foreOrBackView.snp.makeConstraints{
            $0.top.equalTo(heightView.snp.bottom).offset(kAutoHei(70))
            $0.centerX.equalToSuperview()
        }
        
    }
}
//MARK: - 体重
extension RJFillInPersonalInformationViewController{
    private
    func configureUIForWeightType() -> Void {
        notice.text = LoginLocation("We will use your health infomation to give you a more accurate motion data")
        addSubview(weightView)
        addSubview(foreOrBackView)
        foreOrBackView.sizeToFit()
        weightView.snp.makeConstraints {
            $0.top.equalTo(notice.snp.bottom).offset(kAutoHei(70))
            $0.left.equalToSuperview().offset(kAutoWid(30))
            $0.right.equalToSuperview().offset(kAutoWid(-30))
            $0.height.equalTo(kAutoHei(301))
        }
        foreOrBackView.snp.makeConstraints{
            $0.top.equalTo(weightView.snp.bottom).offset(kAutoHei(70))
            $0.centerX.equalToSuperview()
        }
    }
    
}
//MARK: - 头像用户名
extension RJFillInPersonalInformationViewController :UIActionSheetDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    private
    func configureUIForNameAndIconType() -> Void {
        obesrveNameChangeCompleteBtnState()
        notice.text = LoginLocation("Add avatars and nicknames,make you more popular")
        addSubview(nameAndIconView)
        nameAndIconView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.top.equalTo(notice.snp.bottom).offset(kAutoHei(41))
            $0.centerX.equalToSuperview()
        }
    }
    //MARK: - Even Resonce
    @objc
    private
    func iconBtnClick(_ button:RJButton) -> Void {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle:LoginLocation("NO") , destructiveButtonTitle: nil, otherButtonTitles: LoginLocation("take a new photo"), LoginLocation("Select photo from gallery"))
            
            actionSheet.show(in: view)
        }else{
            choosePhotoFromLibrary()
        }
    }
    @objc
    private
    func completeBtnClick(_ button:RJButton) -> Void {
        RJPersonInformationModel.sharePerson.name = name.text
        print("完成登录组件")
        RJLoginHelper.endLoginComponent()
    }
    private
    func takePhoto() -> Void {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate   = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        present(imagePicker, animated: true, completion: nil)
    }
    private
    func choosePhotoFromLibrary() -> Void {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate   = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        present(imagePicker, animated: true, completion: nil)
    }
    private
    func setIcon(_ image:UIImage) -> Void {
        RJPersonInformationModel.sharePerson.icon = image
        icon.setImage(image, for: .normal)
    }
    //MARK: - Observe
    func obesrveNameChangeCompleteBtnState() -> Void {
        DispatchQueue.global().async {
            self.changeStateTimer = Timer.init(timeInterval: 0.1, target: self, selector: #selector(self.changeCompleteButtonState(_:)), userInfo: nil, repeats: true)
            let runloop = RunLoop.current
            runloop.add(self.changeStateTimer!, forMode: .commonModes)
            runloop.run()
        }
    }
    @objc
    private
    func changeCompleteButtonState(_ timer:Timer) -> Void {
        DispatchQueue.main.async {
            if self.name.text?.count == 0 || self.icon.imageView?.image == nil {
                self.complete.isEnabled = false
            }else{
                self.complete.isEnabled = true
            }
        }
        
    }
    //MARK: - UIActionSheetDelegate
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            actionSheet.removeFromSuperview()
        }
        if buttonIndex == 1 {
            takePhoto()
        }
        if buttonIndex == 2{
            choosePhotoFromLibrary()
        }
    }
    //MARK: - UIImagePickerControllerDelegate
    internal
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let imageAny = info[UIImagePickerControllerEditedImage] else { return  }
        let image = imageAny as! UIImage
        setIcon(image)
        dismiss(animated: true, completion: nil)
    }
    
    
}
