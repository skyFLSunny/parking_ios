//
//  TCSingleClickedPayment.swift
//  Parking
//
//  Created by xiaocool on 16/4/25.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCSingleClickedPayment: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var payCars: UILabel!
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var payMethod: UITableView!
    var paycarString:NSMutableString?
    var selectIndex:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "一键支付"
        selectIndex = 0
        configurUI()
    }
    func showVCWithPayCars(cars:Array<TCCarInfoModel>){
        if cars.count == 0 {
            return
        }
        paycarString = "缴费车辆："
        for car in cars {
            paycarString?.appendString(car.carNumber!+" ")
        }
    }
    private func configurUI(){
        if paycarString != nil {
            payCars.text = paycarString!.debugDescription
        }else{
            payCars.text = "无缴费车辆"
        }
        //tableView
        payMethod.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        payMethod.scrollEnabled = false
        payMethod.separatorInset = UIEdgeInsetsZero
        //cornerRadius
        paymentButton.layer.cornerRadius = 8
        //nav
        edgesForExtendedLayout = UIRectEdge.None
        automaticallyAdjustsScrollViewInsets = false
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
    }
    @objc private func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func paymentButtonClicked(sender: AnyObject) {
        
    }
    //MARK:----UITableViewDataSource----
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        switch indexPath.row {
        case 0:
            cell?.imageView?.image = UIImage(named: "ic_weixin")
            cell?.textLabel?.text = "微信支付"
        case 1:
            cell?.imageView?.image = UIImage(named: "ic_zhifubao")
            cell?.textLabel?.text = "支付宝支付"
        case 2:
            cell?.imageView?.image = UIImage(named: "ic_yinghangkazhifu")
            cell?.textLabel?.text = "银行卡支付"
        default:0
        }
        let clickImageView = UIImageView(frame: CGRectMake(0, 0, 15, 15))
        if selectIndex == indexPath.row{
            clickImageView.image = UIImage(named: "weixuan_pressed")
            cell?.accessoryView = clickImageView
        }else{
            clickImageView.image = UIImage(named: "weixuan_normal")
            cell?.accessoryView = clickImageView
        }
        
        return cell!
    }
    //MARK:----tableViewDelegate-------
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        selectIndex = indexPath.row
        tableView.reloadData()
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 60
    }
}
