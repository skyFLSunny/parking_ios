//
//  CarInfoCell.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/17.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class CarInfoCell: UITableViewCell {

    @IBOutlet weak var payInfo: UILabel!
    @IBOutlet weak var carBrand: UILabel!
    @IBOutlet weak var carNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.accessoryType = .DisclosureIndicator
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func setCellWithCarInfo(carInfo:CarCellInfoModel){
        carNumber.text = carInfo.carnumber
        carBrand.text = carInfo.brand
    }
    
}
