//
//  TCUserUnpayModel.swift
//  Parking
//
//  Created by xiaocool on 16/5/20.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCUserUnpayModel: JSONJoy {
    
    var status:String?
    var datas:Array<UserUnpayModel>?
    var errorData:String?
    var datastring:String?
    
    init(){
    }
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            for childs:JSONDecoder in decoder["data"].array! {
                datas?.append(UserUnpayModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
    }
}

class UserUnpayModel:JSONJoy {
    var car_number:String?
    var brand:String?
    var owner_id:Int?
    var car_type:String?
    var date:String?
    var time:String?
    var park:String?
    var position:String?
    var pay_user_id:Int?
    var money:Float?
    var pay_type:Int?
    var status:Int?
    
    required init(_ decoder:JSONDecoder){
        car_number = decoder["car_number"].string
        brand = decoder["brand"].string
        owner_id = decoder["owner_id"].integer
        car_type = decoder["car_type"].string
        date = decoder["date"].string
        time = decoder["time"].string
        park = decoder["park"].string
        position = decoder["position"].string
        pay_user_id = decoder["pay_user_id"].integer
        money = decoder["money"].float
        pay_type = decoder["pay_type"].integer
        status = decoder["status"].integer
    }
}
