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
    var payOrder:String?
    var selectIndex:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支付"
        selectIndex = 0
        configurUI()
    }
    func showVCWithPayCars(carNum:String,cost:String,myPayOrder:String){
        if carNum == ""  {
            paycarString = "无缴费车辆"
        }
        paycarString = "缴费车辆：" + carNum
        if cost.isEmpty{
            return
        }
        myCost = cost
        payOrder = myPayOrder
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
        print(payOrder!)
        print(paycarString!)
        print(myCost!)
        if self.paycarString == nil || myCost == nil || payOrder == nil || myCost == "￥"{
            let alert = UIAlertView.init(title: "系统消息", message: "支付订单信息错误，请重试", delegate: self, cancelButtonTitle: "确定")
            
            alert.show()
            return
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(self.nextView),
                                                         name: "backParkingFormWXPay", object: nil)
        
        let ns3=(self.myCost! as NSString).substringWithRange(NSMakeRange(1, (self.myCost! as NSString).length-1))
//        print(ns3 as NSString)
        
        let a = ns3 as NSString
        let b = a.doubleValue
        let c = Int(b)*100
//        print(c)
////        print()
//        print(Int(ns3))
//        print(String(Int((ns3  as String))!*100))
//        var numPay =
        if selectIndex == 0 {
//            self.myCost!
            TCUserInfo.currentInfo.payOrder = self.payOrder!
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let dateStr = dateFormatter.stringFromDate(NSDate())
            let lastorder = self.payOrder!+"_"+dateStr
            FZJWeiXinPayMainController().testStart(String(c), orderName: self.paycarString!,payOrder: lastorder)
        }else{
            let partner = "2088221951489991"
            let seller = "wongzin@126.com"
            let privateKey = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANGJE3ZFmGUzOQFON4rlLxPAR5Kp8E4lgOUjJe71mS8QJdGsJFdGBnBCUROL+iMJFM2NLCi97e7nALevPQd4QP5Ic1oBvgLlLWFwjLVEmzVBJuxboZLO7WXuYZA2NuGmOMZO//FJukAgyfHe5vrbxtUjf5JBv5gtgJs+Xudn0CTbAgMBAAECgYBleEU1fERtlZ2gdTlOiOgAX5gJfURDA8Rksl23V7Yj5WT7IarDnMSXbnYGyj2K4+XwGNJutHNZwwJE8ZbTXDfUS5Wl442mwSCM0aGzjiqSXbJLUTVBu0Cq2kfESl0j07yyeHGPu+dzFCjbZjwq4bxWgiVB3+xK6vSsZEqcegplQQJBAPYA2ibtPERR/imvkvQflN4skKfq2agV2DZhRMzMQ0DC0/lKaJ0jWUGZlKyxD/6rV3kq9D/5RqPdk1aXJYg/DXsCQQDaDNor4rBLaIQhHg7iPWYY8K/F39qQ949O6JEm4+j6cOMrRacnJ8O66lHk/tb/SFJF2cBRyn105MS0k0/oTbghAkA2NN/dHf9eqpaPxvFhu6fJARbq+VP2tsGK0gof+o6DMasVznCY15YuX1Ikb2uv2T+QIofppNsM9qElvm51xDcLAkEAjCzk+H9znBalknCzWsfj4bahGRDufnFXhH/ICHtNo+p8b64IZgiPMJNAcHlPl69TjKoOk8Yb3tDOj9N/9DQ6YQJAddZBixDawvXPvr64n3k1pbFqzBxSskidrpJ+KmaOwWEmDmrM74sqIjviurUSoFsP+5Q/9+ZYz+BS6tfjCcpN6Q==";
            
//            let privateKey = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANGJE3ZFmGUzOQFO" + "N4rlLxPAR5Kp8E4lgOUjJe71mS8QJdGsJFdGBnBCUROL+iMJFM2NLCi97e7nALev" + "PQd4QP5Ic1oBvgLlLWFwjLVEmzVBJuxboZLO7WXuYZA2NuGmOMZO//FJukAgyfHe" + "5vrbxtUjf5JBv5gtgJs+Xudn0CTbAgMBAAECgYBleEU1fERtlZ2gdTlOiOgAX5gJ" + "fURDA8Rksl23V7Yj5WT7IarDnMSXbnYGyj2K4+XwGNJutHNZwwJE8ZbTXDfUS5Wl" + "442mwSCM0aGzjiqSXbJLUTVBu0Cq2kfESl0j07yyeHGPu+dzFCjbZjwq4bxWgiVB"
            
            let order = Order()
            order.partner = partner;
            order.sellerID = seller;
            order.outTradeNO = payOrder!; //订单ID（由商家自行制定）
            TCUserInfo.currentInfo.payOrder = order.outTradeNO
            order.subject = self.paycarString!; //商品标题
            order.body = " "; //商品描述
//            var money =
            order.totalFee = ns3 as String; //商品价格
            TCUserInfo.currentInfo.payFree = order.totalFee
            order.notifyURL = "http://parking.xiaocool.net/index.php?g=apps&m=index&a=AlipayNotify"; //回调URL，这个URL是在支付之后，支付宝通知后台服务器，使数据同步更新，必须填，不然支付无法成功
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
    
    
    func nextView(){
        let a = self.navigationController?.viewControllers[0]
        self.navigationController?.popToViewController(a!, animated: true)
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