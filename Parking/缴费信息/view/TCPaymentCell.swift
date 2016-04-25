//
//  TCPaymentCell.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/19.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCPaymentCell: UITableViewCell {
    @IBOutlet weak var stopAddress: UILabel!
    @IBOutlet weak var stopDataLabel: UILabel!
    @IBOutlet weak var stopTime: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.payButton.layer.cornerRadius = 4
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func payButtonClicked(sender: AnyObject) {
        print("支付")
    }
}
