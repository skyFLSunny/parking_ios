//
//  Util.swift
//  Parking
//
//  Created by xiaocool on 16/5/17.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import Foundation

let LOGINFO_KEY = "logInfo"
let USER_NAME = "username"
let USER_PWD = "password"
let SHOW_GUIDE = "showguide"
let WIDTH = UIScreen.mainScreen().bounds.size.width
let HEIGHT = UIScreen.mainScreen().bounds.size.height
let PARK_URL_Header = "http://parking.xiaocool.net/index.php?g=apps&m=index"
let PARK_SEND_IMAGE_HEADER = "WriteMicroblog_upload"
let PARK_SHOW_IMAGE_HEADER = "http://parking.xiaocool.net/uploads/microblog/"
let LOAD_CARINFO = "loadCarInfo"


typealias TimerHandle = (timeInterVal:Int)->Void

//计时器类
class TimeManager{
    var taskDic = Dictionary<String,TimeTask>()
    
    //两行代码创建一个单例
    static let shareManager = TimeManager()
    private init() {
    }
    func begainTimerWithKey(key:String,timeInterval:Float,process:TimerHandle,finish:TimerHandle){
        if taskDic.count > 20 {
            print("任务太多")
            return
        }
        if timeInterval>120 {
            print("不支持120秒以上后台操作")
            return
        }
        if taskDic[key] != nil{
            print("存在这个任务")
            return
        }
        let task = TimeTask().configureWithTime(key,time:timeInterval, processHandle: process, finishHandle:finish)
        taskDic[key] = task
    }
}
class TimeTask :NSObject{
    var key:String?
    var FHandle:TimerHandle?
    var PHandle:TimerHandle?
    var leftTime:Float = 0
    var totolTime:Float = 0
    var backgroundID:UIBackgroundTaskIdentifier?
    var timer:NSTimer?
    
    func configureWithTime(myKey:String,time:Float,processHandle:TimerHandle,finishHandle:TimerHandle) -> TimeTask {
        backgroundID = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(nil)
        key = myKey
        totolTime = time
        leftTime = totolTime
        FHandle = finishHandle
        PHandle = processHandle
        timer = NSTimer(timeInterval: 1.0, target: self, selector:#selector(sendHandle), userInfo: nil, repeats: true)
        
        //将timer源写入runloop中被监听，commonMode-滑动不停止
        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        return self
    }
    
    func sendHandle(){
        leftTime -= 1
        if leftTime > 0 {
            if PHandle != nil {
                PHandle!(timeInterVal:Int(leftTime))
            }
        }else{
            timer?.invalidate()
            TimeManager.shareManager.taskDic.removeValueForKey(key!)
            if FHandle != nil {
                FHandle!(timeInterVal: 0)
            }
        }
    }
}

//正则验证类
class RegularExpression{
    //身份证
    class func validateIdentityCard(card:String) -> Bool{
        let string = NSString(string: card)
        let length =  NSString(string: card).length
        if length != 15 && length != 18 {
            return false
        }
        var regex:String?
        if length == 15 {
            regex = "^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$"
        }else{
            regex = "^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$"
        }
        let predicate = NSPredicate.init(format: "SELF MATCHES %@",regex!)
        
        return predicate.evaluateWithObject(string)
    }}


