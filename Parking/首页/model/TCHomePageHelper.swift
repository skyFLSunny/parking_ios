//
//  TCHomePageHelper.swift
//  Parking
//
//  Created by xiaocool on 16/5/16.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCHomePageHelper: NSObject {
    var requestManager:AFHTTPSessionManager?
    
    override init() {
        super.init()
        requestManager = AFHTTPSessionManager()
        requestManager?.responseSerializer = AFHTTPResponseSerializer()
    }
    //获取停车场信息
    func getParkingInfo(handle:ResponseBlock){
        let paramDic = ["a":"getcarlocation","carnumber":TCUserInfo.currentInfo.currentCar]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, success: { (task, response) in
            let result = TCParkingInfoParser(JSONDecoder(response!))
            if result.status == "success"{
                handle(success: true,response: result.data)
            }else {
                handle(success: false,response: result.errorData)
            }
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
}
