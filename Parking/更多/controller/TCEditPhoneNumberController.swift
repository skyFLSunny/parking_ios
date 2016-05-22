//
//  TCEditPhoneNumberController.swift
//  Parking
//
//  Created by xiaocool on 16/5/13.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCEditPhoneNumberController: UIViewController {
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var coderNumber: UITextField!
    
    var moreHelper:TCMoreInfoHelper?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        moreHelper = TCMoreInfoHelper()
        
        self.title = "修改手机号"
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        
        phoneNumber.layer.borderColor = UIColor.whiteColor().CGColor
        phoneNumber.layer.borderWidth = 2
        
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
        // Do any additional setup after loading the view.
    }
    func backToHome(){
        navigationController?.popViewControllerAnimated(true)
    }
    func submit(){
        if phoneNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入手机号")
            return
        }
        moreHelper?.changePhoneNumber(phoneNumber.text!, code: "1234", handle: {  [unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), { 
                if success {
                    SVProgressHUD.showSuccessWithStatus("修改成功")
                    TCUserInfo.currentInfo.phoneNumber = self.phoneNumber.text!
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    SVProgressHUD.showErrorWithStatus(response as! String)
                }
            })
        })
        
    }
    @IBAction func getCoderAction(sender: AnyObject) {
        
    }

}
