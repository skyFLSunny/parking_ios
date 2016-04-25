//
//  carStopInfo.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/22.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCCarStopInfo: NSObject {
    ///车辆信息
    var carInfo:TCCarInfoModel?
    ///停车场信息
    var stopAddress:String?
    ///停车开始时间
    var startTime:NSDate?
    ///停车结束时间
    var endTime:NSDate?
    ///停止时间
    var stayTime:Int?
    ///收费标准
    var price:Float?
    ///收费金额
    var money:Float?
    ///缴费情况
    var isPay:Bool?
}
