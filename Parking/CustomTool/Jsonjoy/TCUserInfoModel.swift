//
//  Parking
//
//  Created by xiaocool on 16/5/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation
class TCUserInfoModel: JSONJoy{
    var status:String?
    var data:UserInfo?
    var errorData:String?
    var datastring:String?
    //var uid:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            data = UserInfo(decoder["data"])
        }else{
            errorData = decoder["data"].string
        }
        
    }
}
class UserInfo: JSONJoy {
    var user_name:String?
    var user_phone:String?
    var avatar:String?
    var addr:String?
    var card_id:String?
    var sex:String?
    var current_car:String?
    var id:Int?
    var create_time:Int?
    var status:Int?
    
    init(){
    }
    required init(_ decoder:JSONDecoder){
        user_name = decoder["user_name"].string
        user_phone = decoder["user_phone"].string
        avatar = decoder["avatar"].string
        addr = decoder["addr"].string
        card_id = decoder["card_id"].string
        sex = decoder["sex"].string
        current_car = decoder["current_car"].string
        id = decoder["id"].integer
        create_time = decoder["create_time"].integer
        status = decoder["status"].integer
    }
}