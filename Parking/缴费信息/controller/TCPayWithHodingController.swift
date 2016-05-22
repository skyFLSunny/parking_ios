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
    var carUnPayments:Array<CarUnpayModel> = []

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
        if !carUnPayments.isEmpty {
            return carUnPayments.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    @IBAction func searchBtnClicked(sender: AnyObject) {
        paymentHelper.getUnpayInfoListWithCarNum(searchBar.text!) { (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success{
                    if response == nil{
                        self.carUnPayments.removeAll()
                        self.tableView.reloadData()
                    }else{
                        self.carUnPayments = [response as! CarUnpayModel]
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("paycell") as! TCPaymentCell
        cell.showForModel(carUnPayments[indexPath.row])
        
        return cell
    }
}
