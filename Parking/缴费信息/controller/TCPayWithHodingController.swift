//
//  TCPayWithHodingController.swift
//  Parking
//
//  Created by xiaocool on 16/5/18.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCPayWithHodingController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var paymentHelper:TCPaymentHelper = TCPaymentHelper()
    var carUnpayments:Array<UserUnpayModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "车费代缴"
        searchBtn.layer.cornerRadius = 16
        searchBtn.clipsToBounds = true
        tableView.tableFooterView = UIView()
        edgesForExtendedLayout = UIRectEdge.None
        automaticallyAdjustsScrollViewInsets = false
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome),
                         forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
        tableView.registerNib(UINib(nibName:"TCPaymentCell",bundle: nil),forCellReuseIdentifier: "paycell")
    }
    
    func tapBackView(){
        self.view.endEditing(true)
    }
    
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if carUnpayments != nil {
            return carUnpayments!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    @IBAction func searchBtnClicked(sender: AnyObject) {
        if searchBar.text!.isEmpty {
            return
        }
        
        paymentHelper.getAllOrderByCarNumber(searchBar.text!) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success{
                    self.carUnpayments = (response as! [UserUnpayModel]).filter({ (model) -> Bool in
                        return model.pay_status == 0
                    })
                    self.tableView?.reloadData()
                }else{
                    SVProgressHUD.showErrorWithStatus("加载失败")
                }
            })
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("paycell") as! TCPaymentCell
        cell.showForModel(carUnpayments![indexPath.row])
        cell.payButton.addTarget(self, action: #selector(payBtnAction), forControlEvents: .TouchUpInside)
        cell.payButton.tag = indexPath.row
        return cell
    }
    
    func payBtnAction(btn:UIButton){
        let vc = TCSingleClickedPayment(nibName: "TCSingleClickedPayment", bundle: nil)
        let costStr = "¥" + String(carUnpayments![btn.tag].money)
        vc.showVCWithPayCars(TCUserInfo.currentInfo.currentCar,cost: costStr,myPayOrder: carUnpayments![btn.tag].order_no)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let VC = TCPayDetailController(nibName: "TCPayDetailController",bundle: nil)
        VC.userPayModel = carUnpayments![indexPath.row]
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
}