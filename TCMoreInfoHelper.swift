//
//  TCMoreInfoHelper.swift
//  Parking
//
//  Created by xiaocool on 16/5/13.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCMoreInfoHelper: NSObject {
    var requestManager:AFHTTPSessionManager?
    override init() {
        super.init()
        requestManager = AFHTTPSessionManager()
        requestManager?.responseSerializer = AFHTTPResponseSerializer()
    }
    
    func changePhoneNumber(phoneNum:String,code:String,handle:ResponseBlock){
        let paraDic = ["a":"updatephone","userid":TCUserInfo.currentInfo.userid,
                       "phone":phoneNum,"code":"1234"]
        requestManager?.GET(PARK_URL_Header, parameters: paraDic, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    
    func changeAvatar(handle:ResponseBlock){
        let paraDic = ["a":"updateavatar","userid":TCUserInfo.currentInfo.userid,
                       "avatar":TCUserInfo.currentInfo.avatar]
        requestManager?.GET(PARK_URL_Header, parameters: paraDic, success: { (task, response) in
             let result = Http(JSONDecoder(response!))
             let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
}
