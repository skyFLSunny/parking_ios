//
//  TCParkingModel.swift
//  Parking
//
//  Created by xiaocool on 16/5/16.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//
import UIKit
    
class TCParkingInfoParser: JSONJoy{
    var status:String?
    var data:ParkingInfoModel?
    var errorData:String?
    var datastring:String?
    
    init(){
    }
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            data = ParkingInfoModel(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
        
    }
}

class ParkingInfoModel: JSONJoy {
    var park:String?
    var position:String?
    var start_time:String?
    var end_time:String?
    
    
    required init(_ decoder:JSONDecoder){
        park = decoder["park"].string
        position = decoder["position"].string
        start_time = decoder["start_time"].string
        end_time = decoder["end_time"].string
    }
}
