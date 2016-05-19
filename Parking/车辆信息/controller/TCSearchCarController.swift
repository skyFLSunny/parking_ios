//
//  TCSearchCarController.swift
//  Parking
//
//  Created by xiaocool on 16/5/18.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCSearchCarController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var carHelper:TCCarInfoHelper = TCCarInfoHelper()
    var dataSource:Array<CarCellInfoModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        configureUI()
        carHelper.getCarInfoList {[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), { 
                if success {
                    self.dataSource = response as? Array<CarCellInfoModel>
                    self.tableView.reloadData()
                }
            })
        }
    }
    func configureUI(){
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        title = "车辆查找"
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
        tableView.tableFooterView = UIView()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource != nil {
            return dataSource!.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = dataSource![indexPath.row].carnumber
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let vc = TCPaymentViewController(nibName:"TCPaymentViewController",bundle: nil)
        vc.pushConfigureWithHasNav(false, carNum: dataSource![indexPath.row].carnumber!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func backToHome(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func allCarInfoButtonAction(sender: AnyObject) {
        let vc = TCPaymentViewController(nibName:"TCPaymentViewController",bundle: nil)
        vc.hasNavBtn = false
        navigationController?.pushViewController(vc, animated: true)
    }
}
