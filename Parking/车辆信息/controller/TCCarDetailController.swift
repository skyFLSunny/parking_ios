//
//  TCCarDetailController.swift
//  Parking
//
//  Created by xiaocool on 16/4/26.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCCarDetailController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        //nav
        self.title = "邀请好友"
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
        let rightButton = UIButton(type: .Custom)
        rightButton.frame = CGRectMake(0, 0, 30, 30)
        rightButton.setImage(UIImage(named: "ic_gengduoyoushang"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(rightNavBtnClicked), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton)
    }
    func rightNavBtnClicked(){
        print("下拉")
    }
    
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
}
