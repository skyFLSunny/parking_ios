//
//  TCGuideView.swift
//  Parking
//
//  Created by xiaocool on 16/5/24.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCGuideView: UIView {
    
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var enterApp: UIButton!
    
    var hidEnterBtn:Bool = true
    
    override func awakeFromNib() {
        
    }

    @IBAction func enterAction(sender: AnyObject) {
        
    }
    override func layoutSubviews() {
        enterApp.hidden = hidEnterBtn
    }
}
