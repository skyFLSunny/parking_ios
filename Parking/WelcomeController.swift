//
//  WelcomeController.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class WelcomeColler: UIViewController {
    lazy var scrowWelcome :UIScrollView = {[unowned self] in
        var viewHeight = self.view.frame.size.height
        var viewWidth = self.view.frame.size.width
        var scroll:UIScrollView = UIScrollView(frame: CGRectMake(0,0,viewWidth,viewHeight))
        scroll.contentSize = CGSizeMake(viewWidth*4,viewHeight)
        for index in 0...3{
            var view:UIView = UIView(frame: CGRectMake(CGFloat(index)*viewWidth,0,viewWidth,viewHeight))
            var label :UILabel = UILabel(frame: CGRectMake(200,200,100,30))
            label.text = "welcome"
            view.addSubview(label)
            if index == 3 {
                var insertButton:UIButton = UIButton(type: UIButtonType.System)
                insertButton.backgroundColor = UIColor.redColor()
                insertButton.setTitle("进入APP", forState: UIControlState.Normal)
                insertButton.frame = CGRectMake(200, viewHeight-100, 100, 30)
                insertButton.addTarget(self, action: #selector(enterTheApp), forControlEvents: UIControlEvents.TouchUpInside)
                view.addSubview(insertButton)
            }
            scroll.addSubview(view)
        }
        return scroll
        }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.greenColor();
        self.scrowWelcome.pagingEnabled = true;
        self.view.addSubview(self.scrowWelcome)
        print(self.scrowWelcome.frame)
        print(self.scrowWelcome.contentSize)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setTabbarItemAttribute(controller:UIViewController,normalImageName:String,selectedImageName:String){
        controller.tabBarItem.image = UIImage(named: normalImageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        controller.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        controller.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 54/255, green: 190/255, blue: 100/255, alpha: 1)], forState: .Selected)
        controller.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.blackColor()],forState: .Normal)
    }
    
    func enterTheApp(){
        //login
        let loginVC = TCLoginViewController(nibName: "TCLoginViewController",bundle: nil)
        loginVC.title = "停车缴费"
        let loginNav = UINavigationController(rootViewController:loginVC)
        loginNav.navigationBar.barTintColor = UIColor(red: 54/255, green: 190/255, blue: 100/255, alpha: 1)
        loginNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        let myWindow  = UIApplication.sharedApplication().keyWindow
        myWindow?.rootViewController = loginNav
        return
        
        //controller
        let appGuideController = UITabBarController()
        
        let homePage:UIViewController = TCHomePageController(nibName: "TCHomePageController", bundle:nil)
        homePage.title = "首页"
        setTabbarItemAttribute(homePage, normalImageName: "ic_home", selectedImageName: "ic_home-0")
        let carInfo:UIViewController = TCCarInfoController()
        carInfo.title = "车辆信息"
        setTabbarItemAttribute(carInfo, normalImageName: "ic_qiche-0", selectedImageName: "ic_qiche")
        let payment:UIViewController = TCPaymentViewController()
        payment.title = "缴费信息"
        setTabbarItemAttribute(payment, normalImageName: "ic_jiaofei", selectedImageName: "ic_jiaofei-0")
        let more:UIViewController = TCMoreFunctionController()
        more.title = "更多"
        setTabbarItemAttribute(more, normalImageName: "ic_gengduo", selectedImageName: "ic_gengduo-0")
        //nav
        let homePageNav = UINavigationController(rootViewController: homePage)
        homePageNav.navigationBar.barTintColor = UIColor(red: 54/255, green: 190/255, blue: 100/255, alpha: 1) //backgroundColor
        homePageNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()] //titleColor
        let carInfoNav = UINavigationController(rootViewController: carInfo)
        carInfoNav.navigationBar.barTintColor = UIColor(red: 54/255, green: 190/255, blue: 100/255, alpha: 1) //backgroundColor
        carInfoNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        let paymentNav = UINavigationController(rootViewController: payment)
        paymentNav.navigationBar.barTintColor = UIColor(red: 54/255, green: 190/255, blue: 100/255, alpha: 1) //backgroundColor
        paymentNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        let moreNav = UINavigationController(rootViewController: more)
        moreNav.navigationBar.barTintColor = UIColor(red: 54/255, green: 190/255, blue: 100/255, alpha: 1) //backgroundColor
        moreNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        appGuideController.setViewControllers([homePageNav,carInfoNav,paymentNav,moreNav], animated: true)
        appGuideController.tabBar.barTintColor = .whiteColor()
        let window  = UIApplication.sharedApplication().keyWindow;
        window?.rootViewController = appGuideController;
    }
}