//
//  TCMessagesController.swift
//  Parking
//
//  Created by xiaocool on 16/4/26.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCMessagesController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var msgTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
       
    }
    func configureUI(){
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        //tableview
        msgTableView.registerNib(UINib(nibName: "TCMessageCell",bundle: nil), forCellReuseIdentifier: "cell")
        msgTableView.tableFooterView = UIView()
        //nav
        self.title = "消息"
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
    }
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    // MARK: ---datasoure-----
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        return cell!
    }
    //MARK:---tableViewDelegate--------
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 50
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let msgDetailVC = TCMessageDetailController(nibName: "TCMessageDetailController",bundle: nil)
        navigationController?.pushViewController(msgDetailVC, animated: true)
    }

}
