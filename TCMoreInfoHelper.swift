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
    func sendImageWithImageName(imageName:String,imageData:NSData){
        let paraDic = ["a":"WriteMicroblog_upload"]
        requestManager?.POST(PARK_IMAGE_HEADER, parameters: paraDic, constructingBodyWithBlock: { (formData) in
            formData.appendPartWithFormData(imageData, name: imageName)
            }, success: { (task, response) in
//                let result = Http(JSONDecoder(response!))
            }, failure: { (take, error) in
//                let result = Http(JSONDecoder(error))
        })
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
}
