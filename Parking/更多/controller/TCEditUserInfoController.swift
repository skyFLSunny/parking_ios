//
//  TCEditUserInfoController.swift
//  Parking
//
//  Created by xiaocool on 16/5/11.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCEditUserInfoController: UIViewController,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var keyboardScrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var manBtn: UIButton!
    @IBOutlet weak var womenBtn: UIButton!
    
    var sex = TCUserInfo.currentInfo.sex
    var nameStr:String?
    var phoneNumStr:String?
    var myActionSheet:UIAlertController?
    var moreHelper:TCMoreInfoHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        moreHelper = TCMoreInfoHelper()
        phoneNumber.text = TCUserInfo.currentInfo.phoneNumber
        name.text = TCUserInfo.currentInfo.userName
        addressBtn.setTitle(TCUserInfo.currentInfo.address, forState: .Normal)
        myActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        myActionSheet?.addAction(UIAlertAction(title: "拍照", style: .Default, handler: {[unowned self] (UIAlertAction) in
            dispatch_async(dispatch_get_main_queue(), {
                self.takePhoto()
            })
        }))
        
        if TCUserInfo.currentInfo.avatar != "" {
            let imageUrlStr = PARK_SHOW_IMAGE_HEADER + TCUserInfo.currentInfo.avatar
            let url = NSURL(string: imageUrlStr)
            avatarBtn.sd_setImageWithURL(url, forState: .Normal)
        }
        if sex == "0"{
            womenButtonAction()
        }
        myActionSheet?.addAction(UIAlertAction(title: "从相册获取", style: .Default, handler: { [unowned self] (UIAlertAction) in
            dispatch_async(dispatch_get_main_queue(), {
                self.LocalPhoto()
            })
        }))
        myActionSheet?.addAction(UIAlertAction(title: "取消", style: .Cancel, handler:nil))
    }
    
    func configureUI(){
        //set layer
        name.layer.borderWidth = 2
        name.layer.borderColor = UIColor.whiteColor().CGColor
        avatarBtn.layer.cornerRadius = 40
        avatarBtn.layer.borderWidth = 2
        avatarBtn.layer.borderColor = UIColor.whiteColor().CGColor
        avatarBtn.clipsToBounds = true
        // set nav
        self.title = "修改个人信息"
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
        
        let rightNavBtn = UIButton(type: .Custom)
        rightNavBtn.frame = CGRectMake(0, 0, 60, 30)
        rightNavBtn.setTitle("提交", forState: .Normal)
        rightNavBtn.addTarget(self, action: #selector(submit), forControlEvents: .TouchUpInside)
        let rightItem = UIBarButtonItem(customView: rightNavBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        //gestureRecognizer
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapBackView))
        self.view.addGestureRecognizer(gesture)
    }
    
    func submit(){
        moreHelper?.editPersonalInfoWithUserName(name.text!, sex: sex, cardid: "", addr: (addressBtn.titleLabel?.text)!, handle: { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success{
                    SVProgressHUD.showSuccessWithStatus("修改成功")
                    TCUserInfo.currentInfo.sex = self.sex
                    TCUserInfo.currentInfo.address = self.addressBtn.titleLabel!.text!
                    TCUserInfo.currentInfo.userName = self.name.text!
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    print(response)
                    SVProgressHUD.showErrorWithStatus("修改失败")
                }
            })
        })
    }
    
    func tapBackView(){
        self.view.endEditing(true)
    }
    
    func takePhoto(){
        let sourceType = UIImagePickerControllerSourceType.Camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            self.presentViewController(picker, animated: true, completion: nil)
        }else{
            print("无法打开相机")
        }
    }
    
    func LocalPhoto(){
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // MARK: ------imagepickerDelegate-------
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let type = info[UIImagePickerControllerMediaType] as! String
        if type != "public.image" {
            return
        }
        //裁剪后图片
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        avatarBtn.setImage(image, forState: .Normal)
        let data = UIImageJPEGRepresentation(image, 0.1)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        let imageName = "avatar" + dateStr + TCUserInfo.currentInfo.userid
        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: PARK_SEND_IMAGE_HEADER) { [unowned self] (data) in
            dispatch_async(dispatch_get_main_queue(), {
            let result = Http(JSONDecoder(data))
                if result.status != nil {
                    if result.status! == "success"{
                        let imageName = result.data?.string!
                        TCUserInfo.currentInfo.avatar = imageName!
                        self.changeAvatar()
                    }else{
                        SVProgressHUD.showErrorWithStatus("图片上传失败")
                    }
                }
            })
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func changeAvatar(){
        self.moreHelper?.changeAvatar({(success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success{
                    SVProgressHUD.showSuccessWithStatus("头像修改成功")
                }
            })
        })
    }
    
    @IBAction func editAddress(sender: AnyObject) {
        let pick = AdressPickerView.shareInstance
        // 设置是否显示区县等，默认为false不显示
        pick.showTown=true

        pick.show((UIApplication.sharedApplication().keyWindow)!)
        
        // 选择完成之后回调
        pick.selectAdress { (addressArray) in
            print("选择的地区是: \(addressArray)")
            let areaStr = addressArray.componentsJoinedByString(" ")
            dispatch_async(dispatch_get_main_queue(), {
                 self.addressBtn.setTitle(areaStr, forState: .Normal)
            })
        }

    }
    
    @IBAction func editPhoneNumber(sender: AnyObject) {
        let VC = TCEditPhoneNumberController(nibName: "TCEditPhoneNumberController",bundle: nil)
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func menButtonAction() {
        sex = "1"
        manBtn.setImage(UIImage(named: "ic_tongyixuanzhong"), forState: .Normal)
        womenBtn.setImage(UIImage(named: "ic_weixuanzhong"), forState: .Normal)
    }
    
    @IBAction func womenButtonAction() {
        sex = "0"
        manBtn.setImage(UIImage(named: "ic_weixuanzhong"), forState: .Normal)
        womenBtn.setImage(UIImage(named: "ic_tongyixuanzhong"), forState: .Normal)
    }
    
    @IBAction func selectAvatarAction(sender: AnyObject) {
        print("avatar")
        presentViewController(myActionSheet!, animated: true, completion:nil)
    }
}
