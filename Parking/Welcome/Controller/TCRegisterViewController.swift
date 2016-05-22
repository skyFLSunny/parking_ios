//
//  TCRegisterViewController.swift
//  Parking
//
//  Created by xiaocool on 16/5/9.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCRegisterViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var areaCodeBtn: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var getIDButton: UIButton!
    @IBOutlet weak var identifyNumber: UITextField!
    @IBOutlet weak var passwordNumber: UITextField!
    @IBOutlet weak var secretBtn: UIButton!
    @IBOutlet weak var completeBtn: UIButton!
    
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var manBtn: UIButton!
    @IBOutlet weak var womenBtn: UIButton!
    @IBOutlet weak var realName: UITextField!
    @IBOutlet weak var personCardID: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var backViewHeight: NSLayoutConstraint!
    
    var myActionSheet:UIAlertController?
    var logVM:TCVMLogModel?
    var sex:Int = 1
    var avatarImageName:String?
    var hasAvatar:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        logVM = TCVMLogModel()
        backViewHeight.constant = HEIGHT>568 ?HEIGHT:568
        
        myActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        myActionSheet?.addAction(UIAlertAction(title: "拍照", style: .Default, handler: {[unowned self] (UIAlertAction) in
            dispatch_async(dispatch_get_main_queue(), {
                self.takePhoto()
            })
            }))

        myActionSheet?.addAction(UIAlertAction(title: "从相册获取", style: .Default, handler: { [unowned self] (UIAlertAction) in
            dispatch_async(dispatch_get_main_queue(), {
                self.LocalPhoto()
            })
            }))
        myActionSheet?.addAction(UIAlertAction(title: "取消", style: .Cancel, handler:nil))
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let type = info[UIImagePickerControllerMediaType] as! String
        if type != "public.image" {
            return
        }
        //裁剪后图片
        /* 此处info 有六个值
         * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
         * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
         * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
         * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
         * UIImagePickerControllerMediaURL;       // an NSURL
         * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
         * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
         */
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
                        let imageName = (result.data?.string)!
                        self.avatarImageName = imageName
                        print(imageName)
                        self.hasAvatar = true
                    }else{
                        SVProgressHUD.showErrorWithStatus("图片上传失败")
                    }
                }
            })
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
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
    
    func configureUI(){
        //gestureRecognizer
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapBackView))
        self.view.addGestureRecognizer(gesture)
        avatarBtn.layer.cornerRadius = 40
        avatarBtn.clipsToBounds = true
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        getIDButton.layer.cornerRadius = 2
        completeBtn.layer.cornerRadius = 8
        phoneNumber.layer.borderWidth = 2
        phoneNumber.layer.borderColor = UIColor.whiteColor().CGColor
        identifyNumber.layer.borderWidth = 2
        identifyNumber.layer.borderColor = UIColor.whiteColor().CGColor
        passwordNumber.layer.borderWidth = 2
        passwordNumber.layer.borderColor = UIColor.whiteColor().CGColor
        realName.layer.borderWidth = 2
        realName.layer.borderColor = UIColor.whiteColor().CGColor
        personCardID.layer.borderWidth = 2
        personCardID.layer.borderColor = UIColor.whiteColor().CGColor
        address.layer.borderWidth = 2
        address.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.title = "账号注册"
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
    }
    
    func tapBackView(){
        self.view.endEditing(true)
    }
    
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func getIdentifyingAction(sender: AnyObject) {
        if phoneNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入手机号！")
            return
        }
        logVM?.sendMobileCodeWithPhoneNumber(phoneNumber.text!)
        print("get identify")
    }
    
    @IBAction func completeButtonAction(sender: AnyObject) {
        
        if !hasAvatar {
            SVProgressHUD.showErrorWithStatus("请选择头像！")
            return
        }
        
        if phoneNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入姓名")
            return
        }
        
        if phoneNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入身份证")
            return
        }
        
        if phoneNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入地址")
            return
        }
        
        if phoneNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入手机号！")
            return
        }
        
        if identifyNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入验证码!")
            return
        }
        
        if passwordNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入密码!")
            return
        }
        
        
        logVM?.register(phoneNumber.text!, password: passwordNumber.text!, code: identifyNumber.text!, avatar: avatarImageName!, name: realName.text!, devicestate: "", sex: String(sex), cardid: personCardID.text!, addr: address.text!, handle: { [unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    SVProgressHUD.showSuccessWithStatus("注册成功")
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    SVProgressHUD.showErrorWithStatus(response as! String)
                }
            })
        })
    }
    
    @IBAction func manBtnClicked(sender: AnyObject) {
        manBtn.setImage(UIImage(named: "ic_tongyixuanzhong"), forState: .Normal)
        womenBtn.setImage(UIImage(named: "ic_weixuanzhong"), forState: .Normal)
        sex = 1
    }
    
    @IBAction func womenBtnClicked(sender: AnyObject) {
        manBtn.setImage(UIImage(named: "ic_weixuanzhong"), forState: .Normal)
        womenBtn.setImage(UIImage(named: "ic_tongyixuanzhong"), forState: .Normal)
        sex = 0
    }
    
    @IBAction func avatarBtnClicked(sender: AnyObject) {
        
        presentViewController(myActionSheet!, animated: true, completion:nil)
    }
    
    @IBAction func passwordSecretBtnAction(sender: AnyObject) {
        
    }
}
