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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
        print("get identify")
    }
    
    @IBAction func completeButtonAction(sender: AnyObject) {
        print("complete")
    }
    @IBAction func passwordSecretBtnAction(sender: AnyObject) {
    }
}
