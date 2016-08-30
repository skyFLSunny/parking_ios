//
//  TCBankCardController.swift
//  Parking
//
//  Created by xiaocool on 16/5/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCBankCardController: UIViewController {
    
    @IBOutlet weak var emptyInfo: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var cardNum: UILabel!
    var hasBankCard:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "银行卡"
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
        
        backView.layer.cornerRadius = 6
        backView.clipsToBounds = true
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        if TCUserInfo.currentInfo.bankNo.isEmpty {
            hasBankCard = false
            backView.hidden = true
            emptyInfo.hidden = false
        }else{
            hasBankCard = true
            backView.hidden = false
            emptyInfo.hidden = true
            bankName.text = TCUserInfo.currentInfo.banktype
            cardType.text = TCUserInfo.currentInfo.bankBranch
            cardNum.text = TCUserInfo.currentInfo.bankNo
        }
        
        let rightNavBtn = UIButton(type: .Custom)
        rightNavBtn.frame = CGRectMake(0, 0, 60, 30)
        if hasBankCard {
            rightNavBtn.setTitle("修改", forState: .Normal)
            rightNavBtn.addTarget(self, action: #selector(modifyBankCard), forControlEvents: .TouchUpInside)
        }else{
            rightNavBtn.setTitle("添加", forState: .Normal)
            rightNavBtn.addTarget(self, action: #selector(addBankCard), forControlEvents: .TouchUpInside)
        }
        let rightItem = UIBarButtonItem(customView: rightNavBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func modifyBankCard(){
        print("修改")
        let vc = TCEditCardController(nibName: "TCEditCardController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addBankCard(){
        print("添加")
        let vc = TCEditCardController(nibName: "TCEditCardController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func backToHome(){
        navigationController?.popViewControllerAnimated(true)
    }
}