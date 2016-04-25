//
//  TCHomeAlertTableCell.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/19.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCHomeAlertTableCell: UITableViewCell {

    @IBOutlet weak var carNumber: UILabel!
    @IBOutlet weak var checkBox: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBox.userInteractionEnabled = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setCellWithCarInfo(carInfo:TCCarInfoModel){
        carNumber.text = carInfo.carNumber
        carInfo.isSelected! == true ? checkBox.setImage(UIImage(named:"weixuan_pressed"), forState: .Normal) :checkBox.setImage(UIImage(named: "weixuan_normal"), forState: .Normal)
    }
}
