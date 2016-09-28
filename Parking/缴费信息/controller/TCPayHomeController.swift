//
//  TCPayHomeController.swift
//  Parking
//
//  Created by xiaocool on 16/9/4.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//
import UIKit

class TCPayHomeController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var carUnPayments = Array<UserUnpayModel>()
    var payHelper:TCPaymentHelper = TCPaymentHelper()
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hidesBottomBarWhenPushed = false
        let rightButton = UIButton(type: .Custom)
        rightButton.frame = CGRectMake(0, 0, 30, 30)
        rightButton.setImage(UIImage(named:"ic_chazhao"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(rightBarButtonClicked), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        let leftButton = UIButton(type: .Custom)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        leftButton.setImage(UIImage(named:"ic_daijiaofei"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(leftBarButtonClicked), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        tableView.registerNib(UINib.init(nibName: "TCPaymentCell", bundle: nil), forCellReuseIdentifier: "paycell")
//        payHelper.getUnpayInfoListWithCarNum(TCUserInfo.currentInfo.currentCar, handle: { [unowned self] (success, response) in
//            self.carUnpayModel = response as? CarUnpayModel
//            self.tableView?.reloadData()
//        })
        tableView.tableFooterView = UIView()
    }
    override func viewWillAppear(animated: Bool) {
        payHelper.getAllOrderByCarNumber(TCUserInfo.currentInfo.currentCar) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success{
                    self.carUnPayments = (response as! [UserUnpayModel]).filter({ (model) -> Bool in
                        return model.pay_status == 0&&model.status == 1
                    })
                    self.tableView?.reloadData()
                }else{
                    SVProgressHUD.showErrorWithStatus("加载失败")
                }
            })
        }
    }
    func leftBarButtonClicked(){
        let vc = TCPayWithHodingController(nibName: "TCPayWithHodingController",bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func rightBarButtonClicked(){
        let vc = TCSearchCarController(nibName:"TCSearchCarController",bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func touchListPayBtn(btn:UIButton){
        let vc = TCSingleClickedPayment(nibName: "TCSingleClickedPayment", bundle: nil)
        let costStr = "¥" + String(carUnPayments[btn.tag].money)
        vc.showVCWithPayCars(TCUserInfo.currentInfo.currentCar,cost: costStr,myPayOrder: carUnPayments[btn.tag].order_no)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let VC = TCPayDetailController(nibName: "TCPayDetailController",bundle: nil)
        VC.paymentModel = carUnPayments[indexPath.row]
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        let titleLabel = UILabel(frame: CGRectMake(10,5,300,20))
        titleLabel.text = "当前车辆 " + TCUserInfo.currentInfo.currentCar
        titleLabel.font = UIFont.systemFontOfSize(15)
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 85
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carUnPayments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("paycell") as! TCPaymentCell
        cell.payButton.addTarget(self, action: #selector(touchListPayBtn), forControlEvents: .TouchUpInside)
        cell.payButton.tag = indexPath.row
        cell.showForModel(carUnPayments[indexPath.row])
        return cell
    }
}
