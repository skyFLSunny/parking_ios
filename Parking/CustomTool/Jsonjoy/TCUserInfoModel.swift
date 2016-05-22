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
    var user_name:String
    var user_phone:String
    var avatar:String
    var addr:String
    var card_id:String
    var sex:String
    var current_car:String
    var id:Int
    var create_time:Int
    var status:Int
    var bank_type:String
    var bank_branch:String
    var bank_no:String
    var bank_user_name:String
    var car_number:String
    
    required init(_ decoder:JSONDecoder){
        user_name = decoder["user_name"].string!
        user_phone = decoder["user_phone"].string!
        avatar = decoder["avatar"].string!
        addr = decoder["addr"].string!
        card_id = decoder["card_id"].string!
        sex = decoder["sex"].string!
        current_car = decoder["current_car"].string!
        id = decoder["id"].integer!
        create_time = decoder["create_time"].integer!
        status = decoder["status"].integer!
        bank_type = decoder["bank_type"].string!
        bank_branch = decoder["bank_branch"].string!
        bank_no = decoder["bank_no"].string!
        bank_user_name = decoder["bank_user_name"].string!
        car_number = decoder["car_number"].string!
    }
}