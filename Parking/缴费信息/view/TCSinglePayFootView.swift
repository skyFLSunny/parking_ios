//
//  TCSinglePayFootView.swift
//  Parking
//
//  Created by xiaocool on 16/5/12.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

typealias TouchSinglePay = () -> Void

class TCSinglePayFootView: UIView {
    
    @IBOutlet weak var singlePayBtn: UIButton?
    var myHandle:TouchSinglePay?
    var cost:String?
    
    func configureFootViewWithCost(cost:String,handle:TouchSinglePay){
        myHandle = handle
        singlePayBtn!.setTitle("一键支付"+"("+cost+")", forState: .Normal)
    }

    @IBAction func touchSinglePayBtn(sender: AnyObject) {
        myHandle!()
    }
}
