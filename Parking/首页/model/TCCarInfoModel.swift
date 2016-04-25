//
//  carInfoModel.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCCarInfoModel: NSObject {
    ///车牌号
    var carNumber:String?
    ///车型
    var carBrand:String?
    ///车主姓名
    var carOwner:String?
    ///车辆标识
    var carId:String?
    ///发动机号
    var engineNumber:String?
    ///是否为驾驶车辆
    var driving:Bool?
    ///车标图片URL
    var brandImageUrl:String?
    ///停车信息
    var StopInfo:TCCarStopInfo?
    ///是否被选中
    var isSelected:Bool?
    
    func setCarInfoModel(carNumber:String,carBrand:String,
         carOwner:String,carId:String,engineNumber:String,driving:Bool,brandImageUrl:String){
        self.carNumber = carNumber
        self.carBrand = carBrand
        self.carOwner = carOwner
        self.carId = carId
        self.engineNumber = engineNumber
        self.driving = driving
        self.brandImageUrl = brandImageUrl
    }
}
