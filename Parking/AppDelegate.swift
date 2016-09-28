//
//  AppDelegate.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {

    var window: UIWindow?
    var payHelper = TCHomePageHelper()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor.whiteColor())
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let showguide = NSUserDefaults.standardUserDefaults().boolForKey(SHOW_GUIDE)
        
        WXApi.registerApp("wx7663b4812a60b7f6")
//        WXApi.registerApp(<#T##appid: String!##String!#>, withDescription: <#T##String!#>)
        if showguide {
            let loginVC = TCLoginViewController(nibName: "TCLoginViewController",bundle: nil)
            loginVC.title = "智能停车"
            let loginNav = UINavigationController(rootViewController:loginVC)
            loginNav.navigationBar.barTintColor = UIColor(red: 53/255, green: 188/255, blue: 123/255, alpha: 1)
            loginNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
            self.window?.rootViewController = loginNav
        }else{
            let welcomeVC = WelcomeColler()
            window?.rootViewController = welcomeVC
        }
        self.window?.makeKeyAndVisible()
        return true
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //微信支付回调方法15659376762
    
    
    func onResp(resp: BaseResp!) {
        if resp.errCode == 0{
            
            print("pay success")
            print(TCUserInfo.currentInfo.payOrder)
//            var ordernums=TCUserInfo.currentInfo.payOrder
//            var realordernumarray = ordernums.componentsSeparatedByString("_")
//            var realorder = realordernumarray[0]
//            print("zcq")
//            print(realorder)
            self.payHelper.sendPaymentInfo(TCUserInfo.currentInfo.payOrder, type: "2", money: TCUserInfo.currentInfo.payFree, status: "1", handle: { (success, response) in
                TCUserInfo.currentInfo.payFree = ""
                TCUserInfo.currentInfo.payOrder = ""
            })
            NSNotificationCenter.defaultCenter().postNotificationName("backParkingFormWXPay", object: "success", userInfo: nil)

            
        }
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        WXApi.handleOpenURL(url, delegate:self)
            
        return true
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        WXApi.handleOpenURL(url, delegate: self)
        if url.host == "safepay" {
            //http://parking.xiaocool.net/index.php?g=apps&m=index&a=payFees&userid=1462436523046&orderno=12345&money=128&type=1&status=1
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (dic) in
                print(dic)
                if dic["resultStatus"] as! String == "9000" {
                    
                    self.payHelper.sendPaymentInfo(TCUserInfo.currentInfo.payOrder, type: "1", money: TCUserInfo.currentInfo.payFree, status: "1", handle: { (success, response) in
                        TCUserInfo.currentInfo.payFree = ""
                        TCUserInfo.currentInfo.payOrder = ""
                    })
                    NSNotificationCenter.defaultCenter().postNotificationName("backParkingFormWXPay", object: "success", userInfo: nil)
                }
            })
        }
        return true
    }
}

