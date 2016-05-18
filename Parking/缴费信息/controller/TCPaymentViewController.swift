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
    
    let leftTag = 666
    let rightTag = 888
    let scrollTag = 2333
    
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
        let leftTableView = UITableView(frame: CGRectMake(0, 0, tableViewWidth, tableViewHeight))
        leftTableView.tag = leftTag
        leftTableView.registerNib(UINib.init(nibName: "TCPaymentCell", bundle: nil), forCellReuseIdentifier: "paycell")
        let rightTableView = UITableView(frame:CGRectMake(tableViewWidth, 0, tableViewWidth, tableViewHeight))
        rightTableView.tag = rightTag
        rightTableView.registerNib(UINib.init(nibName: "TCHasPaiedCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        leftTableView.dataSource = self
        leftTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.delegate = self
        
        let foot = NSBundle.mainBundle().loadNibNamed("TCSinglePayFootView", owner: nil, options: nil).first as! TCSinglePayFootView
        foot.frame = CGRectMake(0,0,20,100)
        foot.configureFootViewWithCost("100元") {
            print("点了一键支付")
        }
        leftTableView.tableFooterView = foot
        
        self.bottomScrollView.addSubview(leftTableView)
        self.bottomScrollView.addSubview(rightTableView)
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
        titleLabel.text = "当前车辆 京B88888"
        titleLabel.font = UIFont.systemFontOfSize(15)
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let VC = TCPayDetailController(nibName: "TCPayDetailController",bundle: nil)
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell
        if tableView.tag == leftTag {
            cell = tableView.dequeueReusableCellWithIdentifier("paycell")!
        }else{
            cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        }
        return cell
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
