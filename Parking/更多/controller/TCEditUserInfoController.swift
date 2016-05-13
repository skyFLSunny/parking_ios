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
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phoneNumber: UILabel!
    
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
        address.text = TCUserInfo.currentInfo.address
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
    
    func configureUI(){
        //set layer
        name.layer.borderWidth = 1
        name.layer.borderColor = UIColor.whiteColor().CGColor
        address.layer.borderColor = UIColor.whiteColor().CGColor
        address.layer.borderWidth = 1
        avatarBtn.layer.cornerRadius = 40
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
        var data:NSData
        if UIImagePNGRepresentation(image) == nil {
            data = UIImageJPEGRepresentation(image, 1.0)!
        }else{
            data = UIImagePNGRepresentation(image)!
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        let imageName = "avatar" + dateStr + TCUserInfo.currentInfo.userid
        
        moreHelper?.sendImageWithImageName(imageName, imageData: data)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func editPhoneNumber(sender: AnyObject) {
        let VC = TCEditPhoneNumberController(nibName: "TCEditPhoneNumberController",bundle: nil)
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func selectedEditPassword(sender: AnyObject) {
        print("pwd")
    }
    @IBAction func selectAvatarAction(sender: AnyObject) {
        print("avatar")
        presentViewController(myActionSheet!, animated: true, completion:nil)
    }
}
