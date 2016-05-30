//
//  TCEditCardController.swift
//  Parking
//
//  Created by xiaocool on 16/5/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCEditCardController: UIViewController {

    @IBOutlet weak var bankName: UITextField!
    @IBOutlet weak var bankBranchName: UITextField!
    @IBOutlet weak var accountName: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var completeBtn: UIButton!
    
    var helper:TCMoreInfoHelper = TCMoreInfoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }
    func configureUI(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hiddenKeyBoard))
        self.view.addGestureRecognizer(gesture)
        bankName.layer.borderColor = UIColor.whiteColor().CGColor
        bankName.layer.borderWidth = 2
        bankBranchName.layer.borderColor = UIColor.whiteColor().CGColor
        bankBranchName.layer.borderWidth = 2
        accountName.layer.borderColor = UIColor.whiteColor().CGColor
        accountName.layer.borderWidth = 2
        cardNumber.layer.borderColor = UIColor.whiteColor().CGColor
        cardNumber.layer.borderWidth = 2

        bankName.text = TCUserInfo.currentInfo.banktype
        bankBranchName.text = TCUserInfo.currentInfo.bankBranch
        accountName.text = TCUserInfo.currentInfo.bankUserName
        cardNumber.text = TCUserInfo.currentInfo.bankNo
        
        completeBtn.layer.cornerRadius = 8
        completeBtn.clipsToBounds = true
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.title = "银行卡信息"
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
        
    }
    func backToHome(){
        navigationController?.popViewControllerAnimated(true)
    }
    func hiddenKeyBoard(){
        self.view.endEditing(true)
    }
    @IBAction func completeAction(sender: AnyObject) {
        if bankName.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入银行名称")
            return
        }
        if bankBranchName.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入支行名称")
            return
        }
        if accountName.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入账号名称")
            return
        }
        if cardNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入银行卡号")
            return
        }
        helper.sendCardInfoWithBankName(bankName.text!, branchName: bankBranchName.text!, accountName: accountName.text!, cardNum: cardNumber.text!) { [unowned self](success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success { 
                    SVProgressHUD.showSuccessWithStatus("修改成功")
                    //TODO: userinfo
                    TCUserInfo.currentInfo.bankNo = self.cardNumber.text!
                    TCUserInfo.currentInfo.bankBranch = self.bankBranchName.text!
                    TCUserInfo.currentInfo.banktype = self.bankName.text!
                    TCUserInfo.currentInfo.bankUserName = self.accountName.text!
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    SVProgressHUD.showErrorWithStatus(response as! String)
                }
            })
        }
    }
}
