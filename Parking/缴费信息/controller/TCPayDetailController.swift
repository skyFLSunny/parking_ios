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
    @IBOutlet weak var stopAddress: UILabel!
    @IBOutlet weak var enterTime: UILabel!
    @IBOutlet weak var exportTime: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var totalCost: UILabel!
    var paymentModel:UserUnpayModel?
    var userPayModel:UserUnpayModel?
    var carUnpayModel:CarUnpayModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "详细信息"
        carBrand.text = TCUserInfo.currentInfo.currentCarBrand
        carNum.text = TCUserInfo.currentInfo.currentCar
        
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
            stopAddress.text = paymentModel?.park
            enterTime.text = paymentModel?.start_time
            exportTime.text = paymentModel?.end_time
            priceLabel.text = "¥"+String(paymentModel!.price)+"/15分钟"
            totalTime.text = paymentModel?.time
            totalCost.text = "¥" + String(paymentModel!.money)
        }
        
        if userPayModel != nil {
            stopAddress.text = userPayModel?.park
            enterTime.text = userPayModel?.start_time
            exportTime.text = userPayModel?.end_time
            priceLabel.text = "¥"+String(userPayModel!.price)+"/15分钟"
            totalTime.text = userPayModel?.time
            totalCost.text = "¥" + String(userPayModel!.money)
        }
        
        if carUnpayModel != nil {
            
        }
    }
    
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
}