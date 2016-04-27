//
//  TCMessageCell.swift
//  Parking
//
//  Created by xiaocool on 16/4/26.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCMessageCell: UITableViewCell {
    @IBOutlet weak var messageIcon: UIImageView!
    @IBOutlet weak var messageContent: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showForMessageModel(model:AnyObject){
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
