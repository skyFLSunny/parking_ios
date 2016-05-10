//
//  TCVMLogModel.swift
//  Parking
//
//  Created by xiaocool on 16/5/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

typealias ResponseBlock = (success:Bool,response:String)->Void

class TCVMLogModel: NSObject {
    var webManager:AFHTTPSessionManager?
    
    override init() {
        super.init()
        webManager = AFHTTPSessionManager()
        webManager?.responseSerializer = AFHTTPResponseSerializer()
    }
    
    func login(phoneNum:String,password:String,handle:ResponseBlock){
        
        let paramDic = ["a":"applogin","phone":"18653503680","password":"123456"]
        
        webManager?.GET(PARK_URL_Header, parameters: paramDic, success: { (task, response) in
                let responseStr = String.init(data: response as! NSData, encoding: NSUTF8StringEncoding)
            let result = Httpresult(JSONDecoder(responseStr!))
                print(responseStr)
            }, failure: { (task, error) in
                print(error)
        })
    }
}
