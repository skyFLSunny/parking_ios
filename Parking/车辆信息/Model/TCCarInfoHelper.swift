//
//  TCCarInfoHelper.swift
//  Parking
//  Created by xiaocool on 16/5/13.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCCarInfoHelper: NSObject {
    
    var requestManager:AFHTTPSessionManager?
    
    override init() {
        super.init()
        if requestManager == nil {
            requestManager = AFHTTPSessionManager()
            requestManager?.responseSerializer = AFHTTPResponseSerializer()
        }
    }
    
    //添加车辆
    func addCarWithOnwerID(brand:String,carNumber:String,carType:String,engineNum:String,handle:ResponseBlock){
        let userid = TCUserInfo.currentInfo.userid
        print(userid)
        let paramDic = ["a":"InsertCarInfo","carnumber":carNumber,"cartype":carType,"userid":userid,"enginenumber":engineNum,"brand":brand]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, success: { (task, response) in
            let result = TCCarInfoParser(JSONDecoder(response!))
            print(result.status)
            print(result.data)
            if result.status == "success" {
                handle(success: true,response: result.data)
            }else{
                handle(success: false,response: result.errorData)
            }
            }, failure: { (task, erre) in
                handle(success: false,response: "网络错误")
        })
    }
    
    //获取车辆信息列表
    func getCarInfoList(handle:ResponseBlock){
        let paramDic = ["a":"getcarlist","userid":TCUserInfo.currentInfo.userid]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, success: { (task, response) in
            let result = CarInfoList(JSONDecoder(response!))
            if result.status == "success" {
                handle(success: true,response: result.objectlist)
            }else{
                handle(success: false,response: result.errorData)
            }
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    
    // 修改车辆信息
    func editCarInfoWithCarID(carid:String,carNumber:String,brand:String,userid:String,
                              cartype:String,engineNum:String, handle:ResponseBlock){
        let paramDic = ["a":"updatecarinfo","carid":carid,
                        "carnumber":carNumber,"brand":brand,
                        "userid":userid,"cartype":cartype,"enginenumber":engineNum]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, success:
            { (task, response) in
                let result = Http(JSONDecoder(response!))
                if result.status == "success" {
                    handle(success: true,response: nil)
                }else{
                    handle(success: false,response: result.errorData)
                }
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    
    //设为常用车辆
    func upDateCurrentCarWithCarNumber(carNum:String,handle:ResponseBlock){
        let paraDic = ["a":"updateMemberCurrentCar",
                       "userid":TCUserInfo.currentInfo.userid,
                       "carnumber":carNum.uppercaseString]
        requestManager?.GET(PARK_URL_Header, parameters: paraDic, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    
    //解绑车辆
    func unBindCarWithCarNumber(carNum:String,handle:ResponseBlock){
        let paraDic = ["a":"unBindCar","userid":TCUserInfo.currentInfo.userid,
                       "carnumber":carNum]
        requestManager?.GET(PARK_URL_Header, parameters: paraDic, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
            handle(success: false,response: "网络错误")
        })
    }
    
    //查询车辆是否是其他用户当前驾驶车辆
    func getCurrentInfoWithCarNumber(carNum:String,handle:ResponseBlock){
        let paraDic = ["a":"checkCurrentCar","userid":TCUserInfo.currentInfo.userid,
                       "carnumber":carNum]
        requestManager?.GET(PARK_URL_Header, parameters: paraDic, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            let responseStr = result.status == "success" ? nil : result.errorData
            handle(success: result.status == "success",response: responseStr)
            }, failure: { (task, error) in
            handle(success: false, response: "网络错误")
        })
    }
}
