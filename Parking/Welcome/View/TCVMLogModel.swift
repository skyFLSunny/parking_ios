//
//  TCVMLogModel.swift
//  Parking
//
//  Created by xiaocool on 16/5/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

typealias ResponseBlock = (success:Bool,response:AnyObject?)->Void

class TCVMLogModel: NSObject {
    var requestManager:AFHTTPSessionManager?
    
    override init() {
        super.init()
        requestManager = AFHTTPSessionManager()
        requestManager?.responseSerializer = AFHTTPResponseSerializer()
    }
    //登录
    func login(phoneNum:String,password:String,handle:ResponseBlock){
        
        let paramDic = ["a":"applogin","phone":phoneNum,"password":password]
        
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, success: { (task, response) in
            let result = TCUserInfoModel(JSONDecoder(response!))
            TCUserInfo.currentInfo.phoneNumber = result.data?.user_phone
            TCUserInfo.currentInfo.userid = String(result.data?.id)
            
            let responseStr = result.status == "success" ? nil : result.errorData
                handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    //发送验证码
    func sendMobileCodeWithPhoneNumber(phoneNumber:String){
        let paramDic = ["a":"SendMobileCode","phone":phoneNumber]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, success: { (task, obj) in
            }, failure: { (task, error) in})
    }
    //注册
    func register(phone:String,password:String,
                  code:String,avatar:String,name:String,
                  devicestate:String,handle:ResponseBlock){
        let paramDic = ["a":"AppRegister","phone":phone,"password":password,
                        "code":code,"avatar":avatar,"name":name,"devicestate":devicestate]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    //忘记密码
    func forgetPassword(phone:String,code:String,password:String,handle:ResponseBlock){
        let paramDic = ["a":"forgetpwd","phone":phone,"code":code,"password":password]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
                
        })
    }
}
