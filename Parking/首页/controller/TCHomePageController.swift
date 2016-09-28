//
//  TCHomePageController.swift
//  ASwiftProduct
//  Created by xiaocool on 16/4/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI

class TCHomePageController: UIViewController,UITableViewDelegate,UITableViewDataSource,TCAlertSelectViewDelegate {

    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyboardScrollView: UIScrollView!
    @IBOutlet weak var needPayTableView: UITableView!
    @IBOutlet weak var pagmentButton: UIButton!
    @IBOutlet weak var carBrandLabel: UILabel!
    @IBOutlet weak var carNumLabel: UILabel!
    @IBOutlet weak var emptyCurrentCar:UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var costLabel:UILabel!
    @IBOutlet weak var carImage:UIImageView!
    
    var backgroundBtn:UIButton?
    var alertSheet:TCAlertSelectView?
//    var res:ParkingInfoModel?
    var currentcar:UserUnpayModel?
    var homeHelper:TCHomePageHelper = TCHomePageHelper()
    var carUnPayments = Array<UserUnpayModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        self.needPayTableView.tableFooterView = UIView()
        self.pagmentButton.layer.cornerRadius = 8
        keyboardScrollView.bounces = false
        self.hidesBottomBarWhenPushed = false
        addNavigationItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        homeHelper.getCurrentCarInfo {[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    let car = response as! CarCellInfoModel
                    if car.carnumber != nil && car.brand != nil{
                        TCUserInfo.currentInfo.currentCar = car.carnumber!
                        TCUserInfo.currentInfo.currentCarBrand = car.brand!
                        //未缴费
                        self.homeHelper.getCarAllOrder(car.carnumber!,handle: {[unowned self] (success, response) in
                            dispatch_async(dispatch_get_main_queue(), {
                                if success && response != nil{
                                    self.carUnPayments = response as! Array<UserUnpayModel>
                                    self.needPayTableView.reloadData()
                                }
                            })
                        })
                        self.ShowCarInfo()
                        self.getStopInfo()
                    }
                } else {
                    TCUserInfo.currentInfo.currentCar = ""
                    TCUserInfo.currentInfo.currentCarBrand = ""
                    self.ShowCarInfo()
                    self.getStopInfo()
                }
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        

//        let tabHeight = view.frame.height - 368
//        tableHeightConstraint.constant = tabHeight >= 160 ? tabHeight :160
        print(TCUserInfo.currentInfo.userid)
    }
    
    func ShowCarInfo(){
        if !TCUserInfo.currentInfo.currentCar.isEmpty {
            carImage.image = UIImage(named: "汽车")
            carNumLabel.hidden = false
            carBrandLabel.hidden = false
            emptyCurrentCar.hidden = true
            carNumLabel.text = TCUserInfo.currentInfo.currentCar
        }else{
            carImage.image = UIImage(named: "汽车2")
            carNumLabel.hidden = true
            carBrandLabel.hidden = true
            emptyCurrentCar.hidden = false
        }
        if !TCUserInfo.currentInfo.currentCarBrand.isEmpty {
            carBrandLabel.text = TCUserInfo.currentInfo.currentCarBrand
        }
    }
    
    func getStopInfo(){
        self.currentcar = nil
        if TCUserInfo.currentInfo.currentCar.isEmpty {
            self.locationLabel.text = "无"
            self.startTimeLabel.text = "无"
            self.totalTimeLabel.text = "无"
            self.costLabel.text = "无"
            self.locationLabel.textColor = UIColor.lightGrayColor()
            self.startTimeLabel.textColor = UIColor.lightGrayColor()
            self.totalTimeLabel.textColor = UIColor.lightGrayColor()
            self.costLabel.textColor = UIColor.lightGrayColor()
        }else{
            homeHelper.getParkingInfo({ [unowned self](success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if response == nil {
                        self.locationLabel.text = "暂无"
                        self.startTimeLabel.text = "暂无"
                        self.totalTimeLabel.text = "暂无"
                        self.costLabel.text = "暂无"
                        self.locationLabel.textColor = UIColor.lightGrayColor()
                        self.startTimeLabel.textColor = UIColor.lightGrayColor()
                        self.totalTimeLabel.textColor = UIColor.lightGrayColor()
                        self.costLabel.textColor = UIColor.lightGrayColor()
                        return
                    }
                    if success {
                        let cars = response as! Array<UserUnpayModel>
                        for car in cars {
                            if ((car.pay_status == 0)&&(car.status==0)) {//
//                                self.dataSource![1].append(car)
                                self.currentcar = car
                                
                            }
//                            else{
//                                TCUserInfo.currentInfo.currentCar = car.carnumber!
//                                TCUserInfo.currentInfo.currentCarBrand = car.brand!
//                                self.dataSource![0].append(car)
//                            }
                        }
//                        self.res = response as? ParkingInfoModel
                        if(self.currentcar == nil){
                            self.locationLabel.text = "暂无"
                            self.startTimeLabel.text = "暂无"
                            self.totalTimeLabel.text = "暂无"
                            self.costLabel.text = "暂无"
                            self.locationLabel.textColor = UIColor.lightGrayColor()
                            self.startTimeLabel.textColor = UIColor.lightGrayColor()
                            self.totalTimeLabel.textColor = UIColor.lightGrayColor()
                            self.costLabel.textColor = UIColor.lightGrayColor()
                        }else{
                            print("zcq")
                            print(self.currentcar!.start_time_str)
                        self.locationLabel.text = self.currentcar!.park
                        self.startTimeLabel.text = self.currentcar!.start_time_str
                        self.totalTimeLabel.text = self.currentcar!.time
                        self.costLabel.text = "¥"+String(self.currentcar!.money)
                        self.locationLabel.textColor = UIColor.darkGrayColor()
                        self.startTimeLabel.textColor = UIColor.darkGrayColor()
                        self.totalTimeLabel.textColor = UIColor.darkGrayColor()
                        self.costLabel.textColor = UIColor.orangeColor()
                        }
                    } else {
                        self.locationLabel.text = "暂无"
                        self.startTimeLabel.text = "暂无"
                        self.totalTimeLabel.text = "暂无"
                        self.costLabel.text = "暂无"
                        self.locationLabel.textColor = UIColor.lightGrayColor()
                        self.startTimeLabel.textColor = UIColor.lightGrayColor()
                        self.totalTimeLabel.textColor = UIColor.lightGrayColor()
                        self.costLabel.textColor = UIColor.lightGrayColor()
                    }
                })
            })
        }
    }
    
    func addNavigationItem(){
        let leftButton = UIButton(type: .Custom)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        leftButton.setImage(UIImage(named: "ic_jiahaoyou"), forState:.Normal)
        leftButton.addTarget(self, action: #selector(leftNavBtnClicked), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 85
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return carUnPayments.count
    }
    // 加好友
    func leftNavBtnClicked(){
        print("加好友")
        let sysAddressBookStatus = ABAddressBookGetAuthorizationStatus()
        if sysAddressBookStatus == .Denied {
            SVProgressHUD.showErrorWithStatus("没有获取通迅录权限")
            return
        }
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
        cell?.payButton.addTarget(self, action: #selector(selectedPayButton),
                                  forControlEvents: .TouchUpInside)
        let model = carUnPayments[indexPath.row]
        cell?.showForModel(model)
        //选中cell不改变颜色
        cell!.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell!
    }
    
    func selectedPayButton(sender:UIButton){
        print(sender.tag)
        let cost = "¥" + String((carUnPayments[sender.tag].money))
        
        pushToPaymentController(TCUserInfo.currentInfo.currentCar,cost: cost,payOrder:carUnPayments[sender.tag].order_no )
    }
    
    @IBAction func paymentButtonClicked(sender: UIButton) {
        if ((currentcar == nil)||(self.currentcar?.pay_status == 1)) {
            SVProgressHUD.showErrorWithStatus("没有待支付的停车信息")
            return
        }
        pushToPaymentController(TCUserInfo.currentInfo.currentCar,cost:costLabel.text!,payOrder:carUnPayments[sender.tag].order_no)
    }
    
    func homeBackgroundBtnClicked(){
        backgroundBtn!.removeFromSuperview()
        alertSheet!.removeFromSuperview()
    }
    
    func pushToPaymentController(carNum:String,cost:String,payOrder:String){
        let vc = TCSingleClickedPayment(nibName: "TCSingleClickedPayment", bundle: nil)
        vc.showVCWithPayCars(carNum, cost: cost, myPayOrder: payOrder)
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