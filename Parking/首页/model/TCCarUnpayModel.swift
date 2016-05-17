//
//  TCCarUnpayModel.swift
//  Parking
//
//  Created by xiaocool on 16/5/17.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCCarUnpayModel: JSONJoy{
    var status:String?
    var data:CarUnpayModel?
    var errorData:String?
    var datastring:String?
    
    init(){
    }
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            data = CarUnpayModel(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
        
    }
}

class CarUnpayModel: JSONJoy {
    var date:String?
    var time:String?
    var price:String?
    var money:Int?
    var pay_type:Int?
    var status:Int?
    var pay_status:Int?
    
    
    required init(_ decoder:JSONDecoder){
        date = decoder["date"].string
        time = decoder["time"].string
        price = decoder["price"].string
        money = decoder["money"].integer
        pay_type = decoder["pay_type"].integer
        status = decoder["status"].integer
        pay_status = decoder["pay_status"].integer
    }
}