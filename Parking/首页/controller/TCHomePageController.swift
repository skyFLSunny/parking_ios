//
//  TCHomePageController.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCHomePageController: UIViewController,UITableViewDelegate,UITableViewDataSource,TCAlertSelectViewDelegate {

    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyboardScrollView: UIScrollView!
    @IBOutlet weak var needPayTableView: UITableView!
    @IBOutlet weak var pagmentButton: UIButton!
    @IBOutlet weak var carBrandLabel: UILabel!
    @IBOutlet weak var carNumLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var empTipView: UIImageView!
    
    var backgroundBtn:UIButton?
    var alertSheet:TCAlertSelectView?
    var homeHelper:TCHomePageHelper?
    var carUnPayments:Array<CarUnpayModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        self.needPayTableView.tableFooterView = UIView()
        carUnPayments = []
        self.pagmentButton.layer.cornerRadius = 8
        keyboardScrollView.bounces = false
        self.hidesBottomBarWhenPushed = false
        carNumLabel.text = TCUserInfo.currentInfo.currentCar
        homeHelper = TCHomePageHelper()
        homeHelper?.getParkingInfo({ [unowned self](success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                let res = response as! ParkingInfoModel
                if success {
                    self.locationLabel.text = res.position
                    self.startTimeLabel.text = res.start_time
                    //  self.totalTimeLabel.text = res.end_time
                } else {
                }
            })
        })
        homeHelper?.getUnpayedInfoList({[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), { 
                if success && response != nil{
                    self.carUnPayments = [response as! CarUnpayModel]
                    self.needPayTableView.reloadData()
                }
            })
        })
        addNavigationItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        let tabHeight = view.frame.height - 368
        tableHeightConstraint.constant = tabHeight >= 160 ? tabHeight :160
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
        return 85
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if carUnPayments != nil {
            return carUnPayments!.count
        }
        return 0
    }
    // 加好友
    func leftNavBtnClicked(){
        print("加好友")
        let invitationVC = TCInvitationController(nibName: "TCInvitationController",bundle: nil)
        invitationVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(invitationVC, animated: true)
    }
    
    // 消息
    func rightNavBtnClicked(){
        print("消息")
        let messageVC = TCMessagesController(nibName:"TCMessagesController",bundle: nil )
        messageVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(messageVC, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = NSBundle.mainBundle().loadNibNamed("NeedToPayCell", owner: self, options: nil).first as? NeedToPayCell
        cell?.payButton.tag = indexPath.row
        cell?.payButton.addTarget(self, action: #selector(selectedPayButton), forControlEvents: .TouchUpInside)
        cell?.showForModel(carUnPayments![indexPath.row])
        
        //选中cell不改变颜色
        cell!.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell!
    }
    
    func selectedPayButton(sender:UIButton){
        print(sender.tag)
        let cost = "¥" + String((carUnPayments![sender.tag].money)!)
        pushToPaymentController("888888",cost: cost)
    }
    
    @IBAction func paymentButtonClicked(sender: UIButton) {
        
        pushToPaymentController("666666",cost:"¥12")
//        let keywin = UIApplication.sharedApplication().keyWindow
//        backgroundBtn = UIButton(type: UIButtonType.Custom)
//        backgroundBtn!.backgroundColor = UIColor.blackColor()
//        backgroundBtn!.alpha = 0.4
//        backgroundBtn!.frame = keywin!.bounds
//        backgroundBtn!.addTarget(self, action:#selector(homeBackgroundBtnClicked), forControlEvents: UIControlEvents.TouchUpInside)
//        keywin?.addSubview(backgroundBtn!)
//        let viewWidth = keywin!.bounds.width*0.6
//        let viewHeight = keywin!.bounds.height*0.3
//        let viewX = keywin!.bounds.width*0.2
//        let viewY = keywin!.bounds.height*0.35
//        alertSheet = TCAlertSelectView(frame: CGRectMake(viewX,viewY,viewWidth,viewHeight))
//        alertSheet?.delegate = self
//        keywin?.addSubview(alertSheet!)
    }
    func homeBackgroundBtnClicked(){
        backgroundBtn!.removeFromSuperview()
        alertSheet!.removeFromSuperview()
    }
    func pushToPaymentController(carNum:String,cost:String){
        let vc = TCSingleClickedPayment(nibName: "TCSingleClickedPayment", bundle: nil)
        vc.showVCWithPayCars(carNum,cost: cost)
        navigationController?.pushViewController(vc, animated: true)
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