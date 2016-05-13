//
//  carInfoModel.swift
//  Parking
//
//  Created by xiaocool on 16/5/13.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCCarInfoParser: JSONJoy{
    var status:String?
    var data:CarInfoModel?
    var errorData:String?
    var datastring:String?
    
    init(){
    }
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            data = CarInfoModel(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
        
    }
}
class CarInfoModel: JSONJoy {
    var carnumber:String?
    var brand:String?
    var userid:String?
    var cartype:String?
    var enginenumber:String?

    
    required init(_ decoder:JSONDecoder){
        carnumber = decoder["carnumber"].string
        brand = decoder["brand"].string
        userid = decoder["userid"].string
        cartype = decoder["cartype"].string
        enginenumber = decoder["enginenumber"].string
    }

}
