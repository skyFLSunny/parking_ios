//
//  TCUserInfo.swift
//  Parking
//
//  Created by xiaocool on 16/5/11.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCUserInfo {
    var avatar:String
    var address:String
    var phoneNumber:String
    var userid:String
    var userName:String
    var sex:String
    var currentCar:String
    
    static let currentInfo = TCUserInfo()
    private init() {
        "初始化userInfo"
        avatar = ""
        address = ""
        phoneNumber = ""
        userid = ""
        userName = ""
        sex = ""
        currentCar = ""
    }
}
