//
//  TCEditUserInfoController.swift
//  Parking
//
//  Created by xiaocool on 16/5/11.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCEditUserInfoController: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var keyboardScrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var phoneNumber: UITextField!
    var nameStr:String?
    var phoneNumStr:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        phoneNumber.text = TCUserInfo.currentInfo.phoneNumber
        name.text = TCUserInfo.currentInfo.userName
    }
    func configureUI(){
        //set layer
        name.layer.borderWidth = 1
        name.layer.borderColor = UIColor.whiteColor().CGColor
        phoneNumber.layer.borderWidth = 1
        phoneNumber.layer.borderColor = UIColor.whiteColor().CGColor
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
        //gestureRecognizer
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapBackView))
        self.view.addGestureRecognizer(gesture)
    }
    func tapBackView(){
        self.view.endEditing(true)
    }
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func selectedEditPassword(sender: AnyObject) {
        print("pwd")
    }
    @IBAction func selectAvatarAction(sender: AnyObject) {
        print("avatar")
    }
    @IBAction func selectMyAddress(sender: AnyObject) {
        print("address")
    }
    func scrollViewDidScroll(scrollView: UIScrollView){
        view.endEditing(true)
    }
}
