//
//  TCEditPhoneNumberController.swift
//  Parking
//
//  Created by xiaocool on 16/5/13.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCEditPhoneNumberController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var coderNumber: UITextField!
    @IBOutlet weak var originPwd:UITextField!
    @IBOutlet weak var codeBtn:UIButton!
    @IBOutlet weak var completeBtn:UIButton!
    var moreHelper = TCMoreInfoHelper()
    var logVM = TCVMLogModel()
    var processHandle:TimerHandle?
    var finishHandle:TimerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改手机号"
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        
        codeBtn.layer.cornerRadius = 4
        completeBtn.layer.cornerRadius = 8
        
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
        // Do any additional setup after loading the view.
        processHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                self.codeBtn.backgroundColor = UIColor.lightGrayColor()
                self.codeBtn.userInteractionEnabled = false
                let btnTitle = String(timeInterVal) + "秒后重新获取"
                self.codeBtn.setTitle(btnTitle, forState: .Normal)
            })
        }
        
        finishHandle = {[unowned self] (timeInterVal) in
            dispatch_async(dispatch_get_main_queue(), {
                self.codeBtn.userInteractionEnabled = true
                self.codeBtn.backgroundColor = UIColor(red: 53/255, green: 188/255, blue: 123/255, alpha: 1)
                self.codeBtn.setTitle("获取验证码", forState: .Normal)
            })
        }
        TimeManager.shareManager.taskDic["changePhone"]?.FHandle = finishHandle
        TimeManager.shareManager.taskDic["changePhone"]?.PHandle = processHandle
    }
    
    func backToHome(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        TimeManager.shareManager.taskDic["changePhone"]?.FHandle = nil
        TimeManager.shareManager.taskDic["changePhone"]?.PHandle = nil
    }
    
    @IBAction func getCoderAction(sender: AnyObject) {
        if phoneNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("手机号不能为空")
            return
        }
        
        logVM.comfirmPhoneHasRegister(phoneNumber.text!, handle: {[unowned self](success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    SVProgressHUD.showErrorWithStatus("手机已注册")
                }else{
                    TimeManager.shareManager.begainTimerWithKey("changePhone", timeInterval: 60, process: self.processHandle!, finish: self.finishHandle!)
                    self.logVM.sendMobileCodeWithPhoneNumber(self.phoneNumber.text!)
                }
            })
            })
        
        
    }
    
    @IBAction func completeAction(sender: AnyObject) {
        if phoneNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("手机号不能为空")
            return
        }
        
        if coderNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("验证码不能为空")
            return
        }
        
        if originPwd.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("原始密码不能为空")
            return
        }
        
        moreHelper.changePhoneNumber(phoneNumber.text!, code: coderNumber.text!, pwd: originPwd.text!) { (success, response) in
            if !success {
                SVProgressHUD.showErrorWithStatus("修改失败")
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                SVProgressHUD.showErrorWithStatus("修改成功")
                NSUserDefaults.standardUserDefaults().removeObjectForKey(LOGINFO_KEY)
                let loginVC = TCLoginViewController(nibName: "TCLoginViewController",bundle: nil)
                loginVC.title = "智能停车"
                let loginNav = UINavigationController(rootViewController:loginVC)
                loginNav.navigationBar.barTintColor = UIColor(red: 54/255, green: 190/255, blue: 100/255, alpha: 1)
                loginNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
                let myWindow  = UIApplication.sharedApplication().keyWindow
                myWindow?.rootViewController = loginNav
            })
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView){
        self.view.endEditing(true)
    }
}
