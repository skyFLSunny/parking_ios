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
        let paramDic = ["a":"getAllOrderByCarNumber","carnumber":TCUserInfo.currentInfo.currentCar]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic,progress: nil, success: { (task, response) in
//            let result = TCParkingInfoParser(JSONDecoder(response!))
            let result = TCUserUnpayModel(JSONDecoder(response!))
            if result.status == "success"{
//                print(result.data)
                handle(success: true,response: result.datas)
                
            }else {
                handle(success: false,response: result.errorData)
            }
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    //获取选取车牌号的未缴费信息
    func getUnpayInfoListWithCarNum(carNum:String,handle:ResponseBlock){
        let paramDic = ["a":"getExpenseInfo",
                        "carnumber":carNum,
                        "userid":TCUserInfo.currentInfo.userid]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic,progress: nil, success: { (task, response) in
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
    //获取未缴费帐单
    func getUnpayedInfoList(handle:ResponseBlock){
        let paramDic = ["a":"getExpenseInfo",
                        "carnumber":TCUserInfo.currentInfo.currentCar,
                        "userid":TCUserInfo.currentInfo.userid]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, progress: nil,success: { (task, response) in
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
    //查询用户当前车辆
    func getCurrentCarInfo(handle:ResponseBlock){
        let paramDic = ["a":"getMemberCurrentCar","userid":TCUserInfo.currentInfo.userid]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic,progress: nil, success: { (task, response) in
            let result = HomeCarStopInfo(JSONDecoder(response!))
                if result.status == "success"{
                    handle(success: true, response: result.data)
                }else{
                    handle(success: false,response: "查询失败")
                }
            }, failure: { (task, error) in
                handle(success: false, response: "网络错误")
        })
    }
    //查询用户所有车辆未缴费信息
    func getAllUnpayInfo(handle:ResponseBlock){
        let paramDic = ["a":"getUnpayOrderListByOwner","userid":TCUserInfo.currentInfo.userid]
        requestManager?.GET(PARK_URL_Header, parameters: paramDic,progress: nil, success: { (task, response) in
            let result = TCUserUnpayModel(JSONDecoder(response!))
            
                if result.status == "success"{
                    //TODO:未缴费帐单返回数组
                    handle(success: true,response: result.datas)
                }else{
                    handle(success: false,response: result.errorData)
                }
            
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    //发送短信
    func sendMessageWithPhoneNum(phone:String){
        let paramDic = ["a":"Send","phone":phone,"content":"我在使用智能停车app，快来下载www.pgyer.com/fq12"]
        
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, progress: nil,success: { (task, response) in
            
            }, failure: { (task, error) in
            
        })
    }
    //获取车辆所有订单
    func getCarAllOrder(carNum:String, handle:ResponseBlock){
        let paramDic = ["a":"getAllOrderByCarNumber","carnumber":carNum,"userid":TCUserInfo.currentInfo.userid]
        
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, progress: nil, success: { (task, response) in
            let result = TCUserUnpayModel(JSONDecoder(response!))
            if result.status == "success"{
                //TODO:未缴费帐单返回数组
                handle(success: true,response: result.datas)
            }else{
                handle(success: false,response: result.errorData)
            }
            
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
    //支付缴费信息 1》支付宝 2》微信
    func sendPaymentInfo(orderNo:String, type:String, money:String, status:String, handle:ResponseBlock){
        
        let paramDic = ["a":"payFees","orderno":orderNo,"userid":TCUserInfo.currentInfo.userid, "type":type, "money":money,"status":status]
        
        requestManager?.GET(PARK_URL_Header, parameters: paramDic, progress: nil, success: { (task, response) in
            let result = Http(JSONDecoder(response!))
            if result.status == "success"{
                
               
            }else{
                handle(success: false,response: result.errorData)
            }
            }, failure: { (task, error) in
                handle(success: false,response: "网络错误")
        })
    }
}
