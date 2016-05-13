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
    
    let leftTag = 666
    let rightTag = 888
    let scrollTag = 2333
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge.None
        automaticallyAdjustsScrollViewInsets = false
        hidesBottomBarWhenPushed = false
        addNavItem()
    }
    
    func makeDataSource(){
        
    }
    
    func addNavItem(){
        let leftButton = UIButton(type: .Custom)
        let rightButton = UIButton(type: .Custom)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        rightButton.frame = CGRectMake(0, 0, 30, 30)
        leftButton.setImage(UIImage(named:"ic_daijiaofei"), forState: .Normal)
        rightButton.setImage(UIImage(named:"ic_chazhao"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(leftBarButtonClicked), forControlEvents: .TouchUpInside)
        rightButton.addTarget(self, action: #selector(rightBarButtonClicked), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    func leftBarButtonClicked(){
        print("左导航按钮")
    }
    func rightBarButtonClicked(){
        print("右导航按钮")
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
        rightTableView.registerNib(UINib.init(nibName: "TCPaymentCell", bundle: nil), forCellReuseIdentifier: "paycell")
        
        leftTableView.dataSource = self
        leftTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.delegate = self
        
        let foot = NSBundle.mainBundle().loadNibNamed("TCSinglePayFootView", owner: nil, options: nil).first as! TCSinglePayFootView
        foot.frame = CGRectMake(0,0,20,100)
        foot.configureFootViewWithCost("100万") {
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
        return 100
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        let titleLabel = UILabel(frame: CGRectMake(10,5,300,20))
        titleLabel.text = "当前车辆 鲁F85984"
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
        let cell = tableView.dequeueReusableCellWithIdentifier("paycell")
        return cell!
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
