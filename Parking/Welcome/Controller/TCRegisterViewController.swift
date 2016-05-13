//
//  TCRegisterViewController.swift
//  Parking
//
//  Created by xiaocool on 16/5/9.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCRegisterViewController: UIViewController {
    @IBOutlet weak var areaCodeBtn: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var getIDButton: UIButton!
    @IBOutlet weak var identifyNumber: UITextField!
    @IBOutlet weak var passwordNumber: UITextField!
    @IBOutlet weak var secretBtn: UIButton!
    @IBOutlet weak var completeBtn: UIButton!
    var logVM:TCVMLogModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        logVM = TCVMLogModel()
    }
    
    func configureUI(){
        //gestureRecognizer
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapBackView))
        self.view.addGestureRecognizer(gesture)
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        getIDButton.layer.cornerRadius = 2
        completeBtn.layer.cornerRadius = 8
        phoneNumber.layer.borderWidth = 1
        phoneNumber.layer.borderColor = UIColor.whiteColor().CGColor
        identifyNumber.layer.borderWidth = 1
        identifyNumber.layer.borderColor = UIColor.whiteColor().CGColor
        passwordNumber.layer.borderWidth = 1
        passwordNumber.layer.borderColor = UIColor.whiteColor().CGColor
        
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
        logVM?.register(phoneNumber.text!, password: passwordNumber.text!, code: identifyNumber.text!, avatar: "", name: phoneNumber.text!, devicestate: "", handle: { [unowned self] (success, response) in
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
    @IBAction func passwordSecretBtnAction(sender: AnyObject) {
    }
}
