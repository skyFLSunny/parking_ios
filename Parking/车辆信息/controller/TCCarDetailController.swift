//
//  TCCarDetailController.swift
//  Parking
//
//  Created by xiaocool on 16/4/26.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCCarDetailController: UIViewController {
    var showPopMenu:Bool?
    var popMenu:TCCarDetailPopView?

    override func viewDidLoad() {
        super.viewDidLoad()
        showPopMenu = false
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
        if showPopMenu == false {
            popMenu = NSBundle.mainBundle().loadNibNamed("TCCarDetailPopView", owner: nil, options: nil).first as? TCCarDetailPopView
            let popX = self.view.frame.width-130
            popMenu!.frame = CGRectMake(popX, 0, 125, 100)
            popMenu?.backgroundColor = UIColor.clearColor()
            self.view.addSubview(popMenu!)
            showPopMenu = true
        }else{
            popMenu?.removeFromSuperview()
            popMenu = nil
            showPopMenu = false
        }
        
    }
    
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
}
