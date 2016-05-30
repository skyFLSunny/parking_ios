//
//  TCChangePwdController.swift
//  Parking
//
//  Created by xiaocool on 16/5/23.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCChangePwdController: UIViewController {

    @IBOutlet weak var newPwd: UITextField!
    @IBOutlet weak var confirmPwd: UITextField!
    
    var helper:TCMoreInfoHelper = TCMoreInfoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hiddenKeyBoard))
        self.view.addGestureRecognizer(gesture)
        
        self.title = "修改密码"
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
        // Do any additional setup after loading the view.
    }
    func hiddenKeyBoard(){
        self.view.endEditing(true)
    }
    func backToHome(){
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func completeAction(sender: AnyObject) {
        if newPwd.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入新密码")
            return
        }
        if confirmPwd.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请确认密码")
        }
        if confirmPwd.text! != newPwd.text! {
            SVProgressHUD.showErrorWithStatus("两次输入密码不一致")
        }
        
        helper.changePwdWithNewPwd(newPwd.text!) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    SVProgressHUD.showSuccessWithStatus("修改成功")
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    SVProgressHUD.showErrorWithStatus(response as! String)
                }
            })
        }
    }
}

