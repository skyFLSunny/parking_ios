//
//  TCAboutUsController.swift
//  Parking
//
//  Created by xiaocool on 16/9/14.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
class TCAboutUsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "关于我们"
        
        let aboutLab = UILabel(frame: CGRectMake(20, 20, WIDTH-40, 300))
        aboutLab.numberOfLines = 0
        aboutLab.textColor = UIColor.blackColor()
        aboutLab.font = UIFont.systemFontOfSize(16)
        aboutLab.textAlignment = .Natural
        aboutLab.text = "    智能停车是一款运用“互联网+停车”理念的智慧城市智能停车综合服务平台，旨在为用户提供时尚便捷的停车体验，为运营者提供科学高效的管理方案，有效地解决城市停车难、停车烦的问题。\n\n\n\n\n             福建瀚邦信息工程有限公司"
        aboutLab.frame = aboutLab.frame
        self.view.addSubview(aboutLab)
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

}
