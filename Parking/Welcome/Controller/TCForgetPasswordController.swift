//
//  TCForgetPasswordController.swift
//  Parking
//  Created by xiaocool on 16/5/9.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCForgetPasswordController: UIViewController {

    @IBOutlet weak var areaCode: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var getIDNumBtn: UIButton!
    @IBOutlet weak var identifyNumber: UITextField!
    @IBOutlet weak var passWordNum: UITextField!
    @IBOutlet weak var confirm: UITextField!
    @IBOutlet weak var secretBtn: UIButton!
    @IBOutlet weak var confirmScrtBtn: UIButton!
    @IBOutlet weak var completeBtn: UIButton!
    
    var processHandle:TimerHandle?
    var finishHandle:TimerHandle?
    var logVM:TCVMLogModel?
    var showMM:Bool = false
    var showQRMM:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        logVM = TCVMLogModel()
        
        processHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                self.getIDNumBtn.backgroundColor = UIColor.lightGrayColor()
                self.getIDNumBtn.userInteractionEnabled = false
                let btnTitle = String(timeInterVal) + "秒后重新获取"
                self.getIDNumBtn.setTitle(btnTitle, forState: .Normal)
            })
        }
        
        finishHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                self.getIDNumBtn.userInteractionEnabled = true
                self.getIDNumBtn.backgroundColor = UIColor(red: 53/255, green: 188/255, blue: 123/255, alpha: 1)
                self.getIDNumBtn.setTitle("获取验证码", forState: .Normal)
            })
        }
        TimeManager.shareManager.taskDic["forget"]?.FHandle = finishHandle
        TimeManager.shareManager.taskDic["forget"]?.PHandle = processHandle
    }
    
    func configureUI(){
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapBackView))
        self.view.addGestureRecognizer(gesture)
        //layer
        phoneNumber.layer.borderWidth = 2
        phoneNumber.layer.borderColor = UIColor.whiteColor().CGColor
        identifyNumber.layer.borderWidth = 2
        identifyNumber.layer.borderColor = UIColor.whiteColor().CGColor
        passWordNum.layer.borderWidth = 2
        passWordNum.layer.borderColor = UIColor.whiteColor().CGColor
        confirm.layer.borderWidth = 2
        confirm.layer.borderColor = UIColor.whiteColor().CGColor
        getIDNumBtn.layer.cornerRadius = 2
        completeBtn.layer.cornerRadius = 8
        //nav
        self.title = "修改密码"
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
    
    @IBAction func getIdentifyNumberBtn(sender: AnyObject) {
        if phoneNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入手机号！")
            return
        }
        logVM?.comfirmPhoneHasRegister(phoneNumber.text!, handle: { [unowned self](success, response) in
            dispatch_async(dispatch_get_main_queue(), {
            if success {
                TimeManager.shareManager.begainTimerWithKey("forget", timeInterval: 60, process: self.processHandle!, finish: self.finishHandle!)
                self.logVM?.sendMobileCodeWithPhoneNumber(self.phoneNumber.text!)
            }else{
                    SVProgressHUD.showErrorWithStatus("手机没有注册")
            }
            })
        })
        print("获取验证码")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        TimeManager.shareManager.taskDic["forget"]?.FHandle = nil
        TimeManager.shareManager.taskDic["forget"]?.PHandle = nil
    }
    
    @IBAction func setSecretButtonAction(sender: AnyObject) {
        if showMM == false {
            showMM = true
            secretBtn.setImage(UIImage(named: "ic_zhengyan"), forState: .Normal)
            passWordNum.secureTextEntry = false
        }else{
            showMM = false
            secretBtn.setImage(UIImage(named: "ic_biyan"), forState: .Normal)
            passWordNum.secureTextEntry = true
        }
        print("mima")
    }
    
    @IBAction func setConfirmPassWordButtonAction(sender: AnyObject) {
        if showQRMM == false {
            showQRMM = true
            confirmScrtBtn.setImage(UIImage(named: "ic_zhengyan"), forState: .Normal)
            confirm.secureTextEntry = false
        }else{
            showQRMM = false
            confirmScrtBtn.setImage(UIImage(named: "ic_biyan"), forState: .Normal)
            confirm.secureTextEntry = true
        }
        
        print("qurenmima")
    }
    
    @IBAction func completeButtonAction(sender: AnyObject) {
        if phoneNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入手机号")
            return
        }
        if identifyNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入验证码")
            return
        }
        if passWordNum.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入密码")
            return
        }
        if confirm.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请确认密码")
            return
        }
        if passWordNum.text != confirm.text {
            SVProgressHUD.showErrorWithStatus("两次输入密码不一致")
            return
        }
        logVM?.forgetPassword(phoneNumber.text!, code: identifyNumber.text!, password: passWordNum.text!, handle: { [unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                
                if success {
                    SVProgressHUD.showSuccessWithStatus("修改成功")
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    SVProgressHUD.showErrorWithStatus(response as! String)
                }
                
            })
        })
    }
    
}
