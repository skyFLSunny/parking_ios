//
//  TCHomePageController.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCHomePageController: UIViewController,UITableViewDelegate,UITableViewDataSource,TCAlertSelectViewDelegate {

    @IBOutlet weak var needPayTableView: UITableView!
    @IBOutlet weak var pagmentButton: UIButton!
    var backgroundBtn:UIButton?
    var alertSheet:TCAlertSelectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        self.needPayTableView.tableFooterView = UIView()
        self.pagmentButton.layer.cornerRadius = 8
        addNavigationItem()
    }
    func addNavigationItem(){
        let leftButton = UIButton(type: .Custom)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        leftButton.setImage(UIImage(named: "ic_jiahaoyou"), forState:.Normal)
        let rightButton = UIButton(type: .Custom)
        rightButton.frame = CGRectMake(0, 0, 30, 30)
        rightButton.setImage(UIImage(named: "ic_xiaoxi"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(leftNavBtnClicked), forControlEvents: .TouchUpInside)
        rightButton.addTarget(self, action: #selector(rightNavBtnClicked), forControlEvents: .TouchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton)
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
//        tableView.deselectRowAtIndexPath(indexPath, animated: false)
//    }
    // 加好友
    func leftNavBtnClicked(){
        print("加好友")
        let invitationVC = TCInvitationController(nibName: "TCInvitationController",bundle: nil)
        invitationVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(invitationVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    // 消息
    func rightNavBtnClicked(){
        print("消息")
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = NSBundle.mainBundle().loadNibNamed("NeedToPayCell", owner: self, options: nil).first as? NeedToPayCell
        //选中cell不改变颜色
        cell!.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell!
    }
    
    @IBAction func paymentButtonClicked(sender: AnyObject) {
        let keywin = UIApplication.sharedApplication().keyWindow
        backgroundBtn = UIButton(type: UIButtonType.Custom)
        backgroundBtn!.backgroundColor = UIColor.blackColor()
        backgroundBtn!.alpha = 0.7
        backgroundBtn!.frame = keywin!.bounds
        backgroundBtn!.addTarget(self, action:#selector(homeBackgroundBtnClicked), forControlEvents: UIControlEvents.TouchUpInside)
        keywin?.addSubview(backgroundBtn!)
        let viewWidth = keywin!.bounds.width*0.6
        let viewHeight = keywin!.bounds.height*0.3
        let viewX = keywin!.bounds.width*0.2
        let viewY = keywin!.bounds.height*0.35
        alertSheet = TCAlertSelectView(frame: CGRectMake(viewX,viewY,viewWidth,viewHeight))
        alertSheet?.delegate = self
        keywin?.addSubview(alertSheet!)
    }
    func homeBackgroundBtnClicked(){
        backgroundBtn!.removeFromSuperview()
        alertSheet!.removeFromSuperview()
    }
    //MARK:---TCAlertSelectViewDelegate----
    func cancelButtonClicked(){
        print("取消")
        homeBackgroundBtnClicked()
    }
    func tureButtonClicked(carinfos:Array<TCCarInfoModel>?){
        homeBackgroundBtnClicked()
        print("选择的车辆是：")
        for carInfo in carinfos! {
            print(carInfo.carNumber!)
        }
    }
}
