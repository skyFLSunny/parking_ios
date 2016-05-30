//
//  TCMoreFunctionController.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/21.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCMoreFunctionController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var backScrollView: UIScrollView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var menuHeightCons: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        configurUI()
    }
    
    func configurUI(){
        backScrollView.bounces = false
        hidesBottomBarWhenPushed = false
        avatarButton.layer.cornerRadius = 35
        avatarButton.clipsToBounds = true
        cancelBtn.layer.cornerRadius = 8
        cancelBtn.clipsToBounds = true
        menuTableView.scrollEnabled = false
        menuTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let menuHeight = view.frame.height - 228
        menuHeightCons.constant = menuHeight >= 340 ? menuHeight : 340
        phoneNumLabel.text = TCUserInfo.currentInfo.phoneNumber
        userNameLabel.text = TCUserInfo.currentInfo.userName
        addressLabel.text = TCUserInfo.currentInfo.address == "" ?
            "北京" : TCUserInfo.currentInfo.address
        if TCUserInfo.currentInfo.avatar != "" {
            let imageUrlStr = PARK_SHOW_IMAGE_HEADER + TCUserInfo.currentInfo.avatar
            let url = NSURL(string: imageUrlStr)
            avatarButton.sd_setImageWithURL(url, forState: .Normal)
        }else{
            //男是1，女是0
            if TCUserInfo.currentInfo.sex == "1" {
                avatarButton.setImage(UIImage(named: "avatar_nan"), forState: .Normal)
            }else{
                avatarButton.setImage(UIImage(named: "avatar_nv"), forState: .Normal)
            }
            
        }
        menuTableView.reloadData()

    }
    
    @IBAction func avatarClicked(sender: AnyObject) {
        print("点头像")
    }
    
    @IBAction func editBtnClicked(sender: AnyObject) {
        print("点编辑")
        let VC = TCEditUserInfoController(nibName: "TCEditUserInfoController",bundle: nil)
        VC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func cancelBtnClicked(sender: AnyObject) {
        print("点退出")
        NSUserDefaults.standardUserDefaults().removeObjectForKey(LOGINFO_KEY)
        let loginVC = TCLoginViewController(nibName: "TCLoginViewController",bundle: nil)
        loginVC.title = "停车缴费"
        let loginNav = UINavigationController(rootViewController:loginVC)
        loginNav.navigationBar.barTintColor = UIColor(red: 54/255, green: 190/255, blue: 100/255, alpha: 1)
        loginNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        let myWindow  = UIApplication.sharedApplication().keyWindow
        myWindow?.rootViewController = loginNav
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        switch indexPath.row {
        case 0:
//            cell.textLabel?.text = "银行卡信息"
           print("银行卡信息")
           let vc = TCBankCardController(nibName: "TCBankCardController", bundle: nil)
           vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case 1:
//            cell.textLabel?.text = "账户安全"
            let vc = TCChangePwdController(nibName: "TCChangePwdController", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            print("安全")
        case 2:
//            cell.textLabel?.text = "通知信息"
            print("通知")
        case 3:
//            cell.textLabel?.text = "清理缓存"
            // 取出cache文件夹路径
            let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
            // 打印路径,需要测试的可以往这个路径下放东西
            print(cachePath)
            // 取出文件夹下所有文件数组
            let files = NSFileManager.defaultManager().subpathsAtPath(cachePath!)
            // 用于统计文件夹内所有文件大小
            var big = Int();
            
            
            // 快速枚举取出所有文件名
            for p in files!{
                // 把文件名拼接到路径中
                let path = cachePath!.stringByAppendingFormat("/\(p)")
                // 取出文件属性
                let floder = try! NSFileManager.defaultManager().attributesOfItemAtPath(path)
                // 用元组取出文件大小属性
                for (abc,bcd) in floder {
                    // 只去出文件大小进行拼接
                    if abc == NSFileSize{
                        big += bcd.integerValue
                    }
                }
            }
            
            let message = "\(big/(1024*1024))M缓存"
            let alert = UIAlertController(title: "清除缓存", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            let alertConfirm = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (alertConfirm) -> Void in
                // 点击确定时开始删除
                for p in files!{
                    // 拼接路径
                    let path = cachePath!.stringByAppendingFormat("/\(p)")
                    // 判断是否可以删除
                    if(NSFileManager.defaultManager().fileExistsAtPath(path)){
                        // 删除
                        try? NSFileManager.defaultManager().removeItemAtPath(path)
                    }
                }
            }
            alert.addAction(alertConfirm)
            let cancle = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (cancle) -> Void in
                
            }
            alert.addAction(cancle)
            // 提示框弹出
            presentViewController(alert, animated: true) { () -> Void in
                
            }
            print("清理")
        case 4:
//            cell.textLabel?.text = "检查升级"
            print("升级")
            
        default:0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "银行卡信息"
            cell.imageView?.image = UIImage(named: "ic_yinhangka")
        case 1:
            cell.textLabel?.text = "账户安全"
            cell.imageView?.image = UIImage(named: "ic_zhanghu")
        case 2:
            cell.textLabel?.text = "通知信息"
            cell.imageView?.image = UIImage(named: "ic_tongzhi")
        case 3:
            cell.textLabel?.text = "清理缓存"
            cell.imageView?.image = UIImage(named: "ic_qingli")
        case 4:
            cell.textLabel?.text = "检查升级"
            cell.imageView?.image = UIImage(named: "ic_shengji")
        default:0
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return menuTableView.frame.height/4
    }
}
