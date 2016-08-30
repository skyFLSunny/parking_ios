//
//  TCPaymentViewController.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/17.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCPaymentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    
    @IBOutlet weak var bottomScrollView: UIScrollView!
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var leftPayButton: UIButton!
    @IBOutlet weak var rightPayButton: UIButton!
    
    var leftTableView:UITableView?
    var rightTableView:UITableView?
    var unpaidDataSource:Array<Dictionary<String,TCCarStopInfo>>?
    var paidDataSource:Array<Dictionary<String,TCCarStopInfo>>?
    var hasNavBtn:Bool = true
    var isAll = false
    var carNumber:String?
    var payHelper:TCPaymentHelper = TCPaymentHelper()
    var carUnPayments = Array<UserUnpayModel>()
    var carPayments = Array<UserUnpayModel>()
    var carUnpayModel:CarUnpayModel?
    let leftTag = 666
    let rightTag = 888
    let scrollTag = 2333
    var lab = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI(){
        edgesForExtendedLayout = UIRectEdge.None
        automaticallyAdjustsScrollViewInsets = false
        if hasNavBtn {
            hidesBottomBarWhenPushed = false
            let rightButton = UIButton(type: .Custom)
            rightButton.frame = CGRectMake(0, 0, 30, 30)
            rightButton.setImage(UIImage(named:"ic_chazhao"), forState: .Normal)
            rightButton.addTarget(self, action: #selector(rightBarButtonClicked), forControlEvents: .TouchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
            let leftButton = UIButton(type: .Custom)
            leftButton.frame = CGRectMake(0, 0, 30, 30)
            leftButton.setImage(UIImage(named:"ic_daijiaofei"), forState: .Normal)
            leftButton.addTarget(self, action: #selector(leftBarButtonClicked), forControlEvents: .TouchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        }else{
            let navBtn = UIButton(type: .Custom)
            navBtn.frame = CGRectMake(0, 0, 30, 30)
            navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
            navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
            let navItem = UIBarButtonItem(customView: navBtn)
            self.navigationItem.leftBarButtonItem = navItem
        }
    }
    
    func pushConfigureWithHasNav(hasNav:Bool,carNum:String){
        hasNavBtn = hasNav
        carNumber = carNum
    }
    
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func makeDataSource(){
        
    }
    
    func leftBarButtonClicked(){
        let vc = TCPayWithHodingController(nibName: "TCPayWithHodingController",bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func rightBarButtonClicked(){
        let vc = TCSearchCarController(nibName:"TCSearchCarController",bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let tableViewHeight = self.bottomScrollView.frame.size.height
        let tableViewWidth = self.bottomScrollView.frame.size.width
        self.bottomScrollView.pagingEnabled = true
        self.bottomScrollView.tag = scrollTag
        self.bottomScrollView.contentSize = CGSizeMake(tableViewWidth*2, tableViewHeight)
        if leftTableView == nil {
            leftTableView = UITableView(frame: CGRectMake(0, 0, tableViewWidth, tableViewHeight))
            leftTableView!.tag = leftTag
            leftTableView!.registerNib(UINib.init(nibName: "TCPaymentCell", bundle: nil), forCellReuseIdentifier: "paycell")
            rightTableView = UITableView(frame:CGRectMake(tableViewWidth, 0, tableViewWidth, tableViewHeight))
            rightTableView!.tag = rightTag
            rightTableView!.registerNib(UINib.init(nibName: "TCHasPaiedCell", bundle: nil), forCellReuseIdentifier: "cell")
            leftTableView?.tableFooterView = UIView()
            rightTableView?.tableFooterView = UIView()
            leftTableView?.backgroundColor = UIColor.clearColor()
            rightTableView?.backgroundColor = UIColor.clearColor()
            leftTableView!.dataSource = self
            leftTableView!.delegate = self
            rightTableView!.dataSource = self
            rightTableView!.delegate = self
            
            bottomScrollView.addSubview(leftTableView!)
            bottomScrollView.addSubview(rightTableView!)
        }
        
        if hasNavBtn || isAll {
            payHelper.getAllUnpayInfo( { [unowned self](success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success{
                        self.carUnPayments = response as! [UserUnpayModel]
                        self.leftTableView?.reloadData()
                    }else{
                        SVProgressHUD.showErrorWithStatus("加载失败")
                    }
                })
                })
            payHelper.getAllUserHistroyOrder({ [unowned self](success, response) in
                self.carPayments = response as! [UserUnpayModel]
                self.rightTableView!.reloadData()
                })
        }else{
            let getCarNum = carNumber == nil ?
                TCUserInfo.currentInfo.currentCar : carNumber
            
            payHelper.getUnpayInfoListWithCarNum(getCarNum!, handle: { [unowned self] (success, response) in
                self.carUnpayModel = response as? CarUnpayModel
                self.leftTableView?.reloadData()
            })
            
            payHelper.getHistoryPaymentListWithCarNumber(getCarNum!) { [unowned self](success, response) in
                self.carPayments = response as! [UserUnpayModel]
                self.rightTableView!.reloadData()
            }
        }
        
    }

    @IBAction func leftButtonClicked(sender: AnyObject) {
        print("左边")
        UIView.animateWithDuration(0.3) {
            self.slideView.frame = CGRectMake(0, self.slideView.frame.origin.y, self.slideView.frame.size.width, self.slideView.frame.size.height)
            self.bottomScrollView.contentOffset = CGPointMake(0, 0)
        }
    }
    
    @IBAction func rightButtonClicked(sender: AnyObject) {
        print("右边")
        UIView.animateWithDuration(0.3) {
            let viewWidth = self.view.frame.size.width/2
            self.slideView.frame = CGRectMake(viewWidth, self.slideView.frame.origin.y, self.slideView.frame.size.width, self.slideView.frame.size.height)
            self.bottomScrollView.contentOffset = CGPointMake(self.bottomScrollView.frame.width,0)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 85
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        let titleLabel = UILabel(frame: CGRectMake(10,5,300,20))
        if carNumber == nil {
            titleLabel.text = "当前车辆 " + TCUserInfo.currentInfo.currentCar
        }else{
            titleLabel.text = "当前车辆 " + carNumber!
        }
        titleLabel.font = UIFont.systemFontOfSize(15)
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if hasNavBtn || isAll {
            return 0
        }
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if !hasNavBtn {
            return
        }
        let VC = TCPayDetailController(nibName: "TCPayDetailController",bundle: nil)
        if tableView.tag == leftTag {
            VC.paymentModel = carUnPayments[indexPath.row]
        }else{
            VC.userPayModel = carPayments[indexPath.row]
        }
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.tag == leftTag {
            if hasNavBtn||isAll {
                return carUnPayments.count
            }
            return carUnpayModel == nil ? 0 : 1
        }else{
            let height = tableView.frame.height
            lab.frame = CGRectMake(WIDTH*1.2,height*0.45,WIDTH*0.6,height*0.1)
            lab.text = "当前没有已缴费信息"
            lab.font = UIFont.systemFontOfSize(22)
            lab.adjustsFontSizeToFitWidth = true
            lab.textColor = UIColor.lightGrayColor()
            bottomScrollView.addSubview(lab)
            if carPayments.count == 0 {
                lab.hidden = false
            }else{
                lab.hidden = true
                return carPayments.count
            }
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if tableView.tag == leftTag {
            let cell = tableView.dequeueReusableCellWithIdentifier("paycell") as! TCPaymentCell
            cell.payButton.addTarget(self, action: #selector(touchListPayBtn), forControlEvents: .TouchUpInside)
            cell.payButton.tag = indexPath.row
            if hasNavBtn || isAll {
                cell.showForModel(carUnPayments[indexPath.row])
            }else{
                cell.showForCarModel(carUnpayModel!)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! TCHasPaiedCell
            cell.showforModel(carPayments[indexPath.row])
            return cell
        }
    }
    
    func touchListPayBtn(btn:UIButton){
        let vc = TCSingleClickedPayment(nibName: "TCSingleClickedPayment", bundle: nil)
        let costStr = hasNavBtn||isAll ? "¥"+String(carUnPayments[btn.tag].money) : String(carUnpayModel?.money)
        vc.showVCWithPayCars(TCUserInfo.currentInfo.currentCar,cost: costStr)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        if scrollView.tag != scrollTag {
            return
        }
        print(scrollView.contentOffset.x)
        if scrollView.contentOffset.x == 0 {
            leftButtonClicked(0)
        }else{
            rightButtonClicked(0)
        }
    }
}
