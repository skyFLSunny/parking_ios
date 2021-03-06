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
        
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, progress: nil,success: { (task, response) in
            let result = TCUserInfoModel(JSONDecoder(response!))
            if result.status == "success"{
                TCUserInfo.currentInfo.phoneNumber = (result.data?.user_phone)!
                let userid = (result.data?.id)!
                TCUserInfo.currentInfo.userid = String(userid)
                TCUserInfo.currentInfo.userName = (result.data?.user_name)!
                TCUserInfo.currentInfo.address = (result.data?.addr)!
                TCUserInfo.currentInfo.cardid = (result.data?.card_id)!
                TCUserInfo.currentInfo.bankNo = (result.data?.bank_branch)!
                TCUserInfo.currentInfo.banktype = (result.data?.bank_type)!
                TCUserInfo.currentInfo.bankBranch = (result.data?.bank_no)!
                TCUserInfo.currentInfo.bankUserName = (result.data?.bank_user_name)!
                TCUserInfo.currentInfo.sex = (result.data?.sex)!
                if result.data?.avatar != nil {
                    TCUserInfo.currentInfo.avatar = (result.data?.avatar)!
                }
            }
            let responseStr = result.status == "success" ? nil : result.errorData
                handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    //发送验证码
    func sendMobileCodeWithPhoneNumber(phoneNumber:String){
        let paramDic = ["a":"SendMobileCode","phone":phoneNumber]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, progress: nil,success: { (task, obj) in
            }, failure: { (task, error) in})
    }
    //注册
    func register(phone:String,password:String,
                  code:String,avatar:String,name:String,
                sex:String,cardid:String,addr:String, handle:ResponseBlock){
        let paramDic = ["a":"AppRegister","phone":phone,"password":password,
                        "code":code,"avatar":avatar,"name":name,
                        "sex":sex,"addr":addr,"cardid":cardid]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic,progress: nil, success: { (task, response) in
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
        requestManager?.GET(PARK_URL_Header, parameters: paramDic,progress: nil, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? "成功" : result.errorData
            if responseStr != nil {
                handle(success: result.status == "success",response: responseStr)
            }
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    //验证手机是否已经注册
    func comfirmPhoneHasRegister(phoneNum:String,handle:ResponseBlock){
        let paraDic = ["a":"isregphone","phone":phoneNum]
        requestManager?.GET(PARK_URL_Header, parameters: paraDic,progress: nil, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
               handle(success: false,response: "网络错误") 
        })
    }
}
