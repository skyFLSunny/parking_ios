//
//  TCPaymentHelper.swift
//  Parking
//
//  Created by xiaocool on 16/5/19.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCPaymentHelper: NSObject {
    var requestManager:AFHTTPSessionManager?
    
    override init() {
        super.init()
        requestManager = AFHTTPSessionManager()
        requestManager?.responseSerializer = AFHTTPResponseSerializer()
    }
    //获取历史缴费信息
    func getHistoryPaymentListWithCarNumber(carNum:String,handle:ResponseBlock){
        let paramDic = ["a":"getCarHistoryOrder",
                        "carnumber":carNum,
                        "userid":TCUserInfo.currentInfo.userid]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            if result.status == "success"{
                //TODO:缴费帐单返回数组
                handle(success: true,response: result.data)
            }else{
                handle(success: false,response: result.errorData)
            }

            }, failure: { (task, response) in
                handle(success: false,response: "网络错误")
        })
    }
    //获取选取车牌号的未缴费信息
    func getUnpayInfoListWithCarNum(carNum:String,handle:ResponseBlock){
        let paramDic = ["a":"getExpenseInfo",
                        "carnumber":carNum,
                        "userid":TCUserInfo.currentInfo.userid]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, success: { (task, response) in
            let result = TCCarUnpayModel(JSONDecoder(response!))
            if result.status == "success"{
                //TODO:未缴费帐单返回数组
                handle(success: true,response: result.data)
            }else{
                handle(success: false,response: result.errorData)
            }
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })

    }
    func getUnpanfoList(handle:ResponseBlock){
        let paramDic = ["a":"getExpenseInfo",
                        "carnumber":TCUserInfo.currentInfo.currentCar,
                        "userid":TCUserInfo.currentInfo.userid]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, success: { (task, response) in
            let result = TCCarUnpayModel(JSONDecoder(response!))
            if result.status == "success"{
                //TODO:未缴费帐单返回数组
                handle(success: true,response: result.data)
            }else{
                handle(success: false,response: result.errorData)
            }
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
}
