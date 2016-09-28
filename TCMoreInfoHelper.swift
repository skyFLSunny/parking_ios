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
    //修改手机号码
    func changePhoneNumber(phoneNum:String,code:String,pwd:String,handle:ResponseBlock){
        let paraDic = ["a":"updatephone","userid":TCUserInfo.currentInfo.userid,"phone":phoneNum,"code":code,"old_password":pwd]
        
        requestManager?.GET(PARK_URL_Header, parameters: paraDic,progress: nil, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    //修改头像
    func changeAvatar(handle:ResponseBlock){
        let paraDic = ["a":"updateavatar","userid":TCUserInfo.currentInfo.userid,
                       "avatar":TCUserInfo.currentInfo.avatar]
        requestManager?.GET(PARK_URL_Header, parameters: paraDic, progress: nil,success: { (task, response) in
             let result = Http(JSONDecoder(response!))
             let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    //发送银行卡信息
    func sendCardInfoWithBankName(bankName:String,branchName:String,accountName:String,cardNum:String,handle:ResponseBlock){
        let paraDic = ["a":"updatememberbankinfo","userid":TCUserInfo.currentInfo.userid,
                       "banktype":bankName,"bankno":branchName,"username":accountName,
                       "branch":cardNum]
        requestManager?.GET(PARK_URL_Header, parameters: paraDic,progress: nil, success: { (task, response) in
                let result = Http(JSONDecoder(response!))
                let responseStr = result.status == "success" ? nil : result.errorData
                handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
               handle(success: false,response: "网络错误")
        })
    }
    //修改密码
    func changePwdWithNewPwd(pwd:String,handle:ResponseBlock){
        let paraDic = ["a":"UpdatePass","phone":TCUserInfo.currentInfo.phoneNumber,"password":pwd]
        requestManager?.GET(PARK_URL_Header, parameters: paraDic,progress: nil, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    //资料编辑
    func editPersonalInfoWithUserName(name:String,sex:String,cardid:String,
                                      addr:String,handle:ResponseBlock){
        let paraDic = ["a":"updatemember","userid":TCUserInfo.currentInfo.userid,
                       "name":name,"addr":addr,"cardid":cardid,"sex":sex]
        requestManager?.GET(PARK_URL_Header, parameters: paraDic,progress: nil, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
               handle(success: false,response: "网络错误")
        })
    }
    //通过手机号码修改密码
    func changePasswordByPhone(old_password:String, new_password:String,handle:ResponseBlock){
        let paraDic = ["a":"changePasswordByPhone","phone":TCUserInfo.currentInfo.phoneNumber,"old_password":old_password,"new_password":new_password]
        requestManager?.GET(PARK_URL_Header, parameters: paraDic,progress: nil, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
}
