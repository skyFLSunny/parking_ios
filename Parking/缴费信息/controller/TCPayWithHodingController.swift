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
    var carUnPayment:CarUnpayModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "车费代缴"
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tapBackView))
        self.view.addGestureRecognizer(gesture)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchBtn.layer.cornerRadius = 16
        searchBtn.clipsToBounds = true
        tableView.tableFooterView = UIView()
        edgesForExtendedLayout = UIRectEdge.None
        automaticallyAdjustsScrollViewInsets = false
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
        tableView.registerNib(UINib(nibName:"TCPaymentCell",bundle: nil), forCellReuseIdentifier: "paycell")
    }
    func tapBackView(){
        self.view.endEditing(true)
    }
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if carUnPayment != nil {
            return 1
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
        
        paymentHelper.getUnpayInfoListWithCarNum(searchBar.text!) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success{
                    if response == nil{
                        self.carUnPayment = nil
                        self.tableView.reloadData()
                    }else{
                        self.carUnPayment = response as? CarUnpayModel
                        self.tableView.reloadData()
                    }
                }else{
                    SVProgressHUD.showErrorWithStatus(response as! String)
                }
            })
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("paycell") as! TCPaymentCell
        cell.showForCarModel(carUnPayment!)
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
