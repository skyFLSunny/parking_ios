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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI(){
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapBackView))
        self.view.addGestureRecognizer(gesture)
        //layer
        phoneNumber.layer.borderWidth = 1
        phoneNumber.layer.borderColor = UIColor.whiteColor().CGColor
        identifyNumber.layer.borderWidth = 1
        identifyNumber.layer.borderColor = UIColor.whiteColor().CGColor
        passWordNum.layer.borderWidth = 1
        passWordNum.layer.borderColor = UIColor.whiteColor().CGColor
        confirm.layer.borderWidth = 1
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
        print("获取验证码")
    }
    
    @IBAction func setSecretButtonAction(sender: AnyObject) {
        print("mima")
    }
    
    @IBAction func setConfirmPassWordButtonAction(sender: AnyObject) {
        print("qurenmima")
    }
    
    @IBAction func completeButtonAction(sender: AnyObject) {
        print("complete")
    }
    
}
