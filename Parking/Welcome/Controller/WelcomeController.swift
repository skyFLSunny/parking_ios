//
//  WelcomeController.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class WelcomeColler: UIViewController {
    
    var scrollView:UIScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        scrollView.contentSize = CGSizeMake(WIDTH*3, HEIGHT)
        scrollView.pagingEnabled = true
        
        let guide1 = NSBundle.mainBundle().loadNibNamed("TCGuideView", owner: nil, options: nil).first as! TCGuideView
        let guide2 = NSBundle.mainBundle().loadNibNamed("TCGuideView", owner: nil, options: nil).first as! TCGuideView
        let guide3 = NSBundle.mainBundle().loadNibNamed("TCGuideView", owner: nil, options: nil).first as! TCGuideView

        guide1.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        guide2.frame = CGRectMake(WIDTH, 0, WIDTH, HEIGHT)
        guide3.frame = CGRectMake(WIDTH*2, 0, WIDTH, HEIGHT)
        
        guide1.backImageView.image = UIImage(named: "guide1")
        guide2.backImageView.image = UIImage(named: "guide2")
        guide3.backImageView.image = UIImage(named: "guide3")
        
        guide3.hidEnterBtn = false
        guide3.enterApp.addTarget(self, action: #selector(enterAppAction), forControlEvents: .TouchUpInside)
        
        scrollView.addSubview(guide1)
        scrollView.addSubview(guide2)
        scrollView.addSubview(guide3)
        
        view.addSubview(scrollView)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: SHOW_GUIDE)
    }
    
    func enterAppAction(){
        let window = UIApplication.sharedApplication().keyWindow
        let loginVC = TCLoginViewController(nibName: "TCLoginViewController",bundle: nil)
        loginVC.title = "智慧停车"
        let loginNav = UINavigationController(rootViewController:loginVC)
        loginNav.navigationBar.barTintColor = UIColor(red: 53/255, green: 188/255, blue: 123/255, alpha: 1)
        loginNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        window?.rootViewController = loginNav
        window?.makeKeyAndVisible()
    }
}