//
//  NeedToPayCell.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class NeedToPayCell: UITableViewCell {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var stopTimeLabel: UILabel!
    @IBOutlet weak var stopInfoLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    var myModel : UserUnpayModel?
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        self.payButton.layer.cornerRadius = 4
        self.payButton.layer.backgroundColor = UIColor(red: 61/255.0, green: 186/255.0, blue: 124/255.0, alpha: 1).CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showForModel(model:UserUnpayModel){
        myModel = model
    }
    
    @IBAction func payment(sender: AnyObject) {
        print("支付")
    }
    override func layoutSubviews() {
        if  myModel != nil {
            if myModel?.money != nil {
                addressLabel.text = myModel!.car_number
                moneyLabel.text = "¥" + String((myModel?.money)!)
                stopTimeLabel.text = myModel?.date
                stopInfoLabel.text = "停车 " + myModel!.time
            }
        }
    }
}
