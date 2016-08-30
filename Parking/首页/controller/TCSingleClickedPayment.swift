//
//  TCSingleClickedPayment.swift
//  Parking
//
//  Created by xiaocool on 16/4/25.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCSingleClickedPayment: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var payCars: UILabel!
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var payMethod: UITableView!
    var paycarString:String?
    var myCost:String?
    var selectIndex:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支付"
        selectIndex = 0
        configurUI()
    }
    func showVCWithPayCars(carNum:String,cost:String){
        if carNum == ""  {
            paycarString = "无缴费车辆"
        }
        paycarString = "缴费车辆：" + carNum
        if cost.isEmpty{
            return
        }
        myCost = cost
    }
    private func configurUI(){
        if paycarString != "" {
            payCars.text = paycarString
        }else{
            payCars.text = "无缴费车辆"
        }
        totalCost.text = myCost
        //tableView
        payMethod.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        payMethod.scrollEnabled = false
        payMethod.separatorInset = UIEdgeInsetsZero
        //cornerRadius
        paymentButton.layer.cornerRadius = 8
        //nav
        edgesForExtendedLayout = UIRectEdge.None
        automaticallyAdjustsScrollViewInsets = false
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
    }
    @objc private func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func paymentButtonClicked(sender: AnyObject) {
        if selectIndex == 0 {
            FZJWeiXinPayMainController().testStart("0.01", orderName: "测试")
        }else{
            let partner = "2088002084967422"
            let seller = "aqian2001@163.com"
            let privateKey = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAK4a3fO2l5Jn82ywtsBmWCKUDz/J0KKqmEXgu2VjO98dMjN7C+eO48kmhEe7JFpwVYZ9+tuO3TsSDonJ1DOsxVY/341/zYr8tV3SPjhChPTObAswUXznQ8qChIP8sCLdakw/YnlxnOvJneztmg++bIlMIGZUZy17rMKCgHTloJ7LAgMBAAECgYBv/RIlUJ7AaqL2l9iFe49Xdps0cbEE4OyfjgWcGq+JPTNsT8qBgLTeTyspJKQmlDk/EEvK7GM7OsslMDCRqKEpYGqgMJDZGYwanUc/gP4PNarsYY9J7yckRNMoUL2X8ROatiHLv2gHhaQ8zqQf0xG9/9uz+RG9KBiOhQzhEb7DmQJBAN40brXMEJdqqAxQ/de80M1vhgSu5nG+d/ztF2JHG/00DlUGu4AWypPL/6Xys5/GaWWCX3/XawZSHeias9NHdS0CQQDIlalKdsuFKSmrtH24hc/fYOp2VsWFUmMSDBzcizytT+zVKs1CBUbk5R7Pg/PS5iyeqYR6fbvs0HuArkD/f87XAkAQPLqeVEQeHHAdPkneWvDTIkQj0XgLdcSk2dpslw+niAdIFU7cRE4XUL/kq4COu1v2S/mYiPBMLPH8jll3pfAdAkAwhGLKbCmWL/qwWZv/Qf6h3WNY9Gwab28fMmbYwaUPlsGGXi//xB79xp3JO/WCEcLBLeepaThHc7YrzfpS0qtJAkEArxp4t06xxjWRKHpZdDFdtzpEdYg0sIDRhfepVCKxI496HRlrlo+7WipncI4Pm5fJIvm0IXbTlmlIVJx8EYKPPA==";
            
            let order = Order()
            order.partner = partner;
            order.sellerID = seller;
            order.outTradeNO = "a512312312"; //订单ID（由商家自行制定）
            order.subject = "测试"; //商品标题
            order.body = "这是测试商品"; //商品描述
            order.totalFee = "0.2"; //商品价格
            order.notifyURL = "http://www.xxx.com"; //回调URL，这个URL是在支付之后，支付宝通知后台服务器，使数据同步更新，必须填，不然支付无法成功
            //下面的参数是固定的，不需要改变
            order.service = "mobile.securitypay.pay";
            order.paymentType = "1";
            order.inputCharset = "utf-8";
            order.itBPay = "30m";
            order.showURL = "m.alipay.com";
            
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            let appScheme = "Parking";
            
            let orderSpec = order.description;
            
            let signer = CreateRSADataSigner(privateKey);
            let signedString = signer.signString(orderSpec);
            if signedString != nil {
                let orderString = "\(orderSpec)&sign=\"\(signedString)\"&sign_type=\"RSA\"";
                
                AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme) { (dic)-> Void in
                    print(dic)
                }
            }
        }
    }
    //MARK:----UITableViewDataSource----
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        switch indexPath.row {
        case 0:
            cell?.imageView?.image = UIImage(named: "ic_weixin")
            cell?.textLabel?.text = "微信支付"
        case 1:
            cell?.imageView?.image = UIImage(named: "ic_zhifubao")
            cell?.textLabel?.text = "支付宝支付"
        case 2:
            cell?.imageView?.image = UIImage(named: "ic_yinghangkazhifu")
            cell?.textLabel?.text = "银行卡支付"
        default:0
        }
        let clickImageView = UIImageView(frame: CGRectMake(0, 0, 15, 15))
        if selectIndex == indexPath.row{
            clickImageView.image = UIImage(named: "weixuan_pressed")
            cell?.accessoryView = clickImageView
        }else{
            clickImageView.image = UIImage(named: "weixuan_normal")
            cell?.accessoryView = clickImageView
        }
        
        return cell!
    }
    //MARK:----tableViewDelegate-------
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        selectIndex = indexPath.row
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 60
    }
}
