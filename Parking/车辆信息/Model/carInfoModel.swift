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

class CarInfoList: JSONJoy {
    var status:String?
    var objectlist: [CarCellInfoModel]
    var count: Int{
        return self.objectlist.count
    }
    var errorData:String?
    init(){
        objectlist = Array<CarCellInfoModel>()
    }
    
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        objectlist = Array<CarCellInfoModel>()
        if status == "success"{
            for childs: JSONDecoder in decoder["data"].array!{
                objectlist.append(CarCellInfoModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
    }
    
    func append(list: [CarCellInfoModel]){
        self.objectlist = list + self.objectlist
    }
}

class CarCellInfoModel:JSONJoy{
    
    var carnumber:String?
    var brand:String?
    var userid:Int?
    var cartype:String?
    var enginenumber:String?
    var carid:Int?
    var opt_time:Int?
    var isCurrentCar:Int?
    var status:String?
    
    
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        carnumber = decoder["car_number"].string
        brand = decoder["brand"].string
        userid = decoder["owner_id"].integer
        cartype = decoder["car_type"].string
        enginenumber = decoder["engine_number"].string
        carid = decoder["id"].integer
        opt_time = decoder["opt_time"].integer
        isCurrentCar = decoder["is_current_car"].integer
        
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
