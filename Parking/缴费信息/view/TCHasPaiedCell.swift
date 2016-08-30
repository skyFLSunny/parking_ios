//
//  TCHasPaiedCell.swift
//  Parking
//
//  Created by xiaocool on 16/5/18.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCHasPaiedCell: UITableViewCell {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    var myModel:UserUnpayModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showforModel(model:UserUnpayModel){
        myModel = model
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if myModel != nil {
            addressLabel.text = myModel!.park
            timeLabel.text = myModel!.date
            priceLabel.text = "停车"+myModel!.time+"小时"
            costLabel.text = "¥"+String(myModel!.money)
        }
    }
    
}
