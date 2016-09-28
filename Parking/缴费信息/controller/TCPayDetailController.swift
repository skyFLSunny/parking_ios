//
//  TCPayDetailController.swift
//  Parking
//
//  Created by xiaocool on 16/5/12.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCPayDetailController: UIViewController {
    
    @IBOutlet weak var carIcon: UIImageView!
    @IBOutlet weak var carBrand: UILabel!
    @IBOutlet weak var carNum: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var exportTime: UILabel!
    @IBOutlet weak var totalCost: UILabel!

    var paymentModel:UserUnpayModel?
    var userPayModel:UserUnpayModel?
    var carUnpayModel:CarUnpayModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "详细信息"
        
        
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if paymentModel != nil {
            carBrand.text = paymentModel?.brand
            carNum.text = paymentModel?.car_number
            exportTime.text = paymentModel!.end_time_str.isEmpty ?paymentModel?.end_time : paymentModel?.end_time_str
            orderNumber.text = paymentModel?.order_no
            totalCost.text = "¥" + String(paymentModel!.money)
        }
        
        if userPayModel != nil {
            carBrand.text = userPayModel?.brand
            carNum.text = userPayModel?.car_number
            exportTime.text = userPayModel!.end_time_str.isEmpty ? userPayModel?.end_time : userPayModel?.end_time_str
            orderNumber.text = userPayModel?.order_no
            totalCost.text = "¥" + String(userPayModel!.money)
        }
        
        if carUnpayModel != nil {
            totalCost.text = "¥"+String(carUnpayModel!.money)
        }
    }
    
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
}