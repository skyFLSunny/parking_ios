//
//  TCCarInfoController.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/17.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCCarInfoController: UITableViewController {
    var dataSource:Array<Array<CarCellInfoModel>>?
    var carInfoHelper:TCCarInfoHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carInfoHelper = TCCarInfoHelper()
        makeDataSource()
        configureUI()
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {[unowned self] in
            self.loadDataSource()
        })
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loadDataSource), name: LOAD_CARINFO, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        carInfoHelper?.requestManager?.operationQueue.cancelAllOperations()
    }
    
    func configureUI(){
        self.hidesBottomBarWhenPushed = false
        
        tableView.registerNib(UINib.init(nibName: "CarInfoCell", bundle: nil), forCellReuseIdentifier: "CarInfoCell")
        tableView.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        tableView.tableFooterView = UIView()
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_tianjiacheliang"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(addCarInfo), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.rightBarButtonItem = navItem
    }
    
    func addCarInfo(){
        print("添加车辆")
        let VC = AddCarViewController(nibName: "AddCarViewController",bundle: nil)
        VC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(VC, animated: true)
        
    }
    
    func makeDataSource(){
        dataSource = [[],[]];
        loadDataSource()
    }
    
    func loadDataSource(){
        carInfoHelper?.getCarInfoList({[unowned self] (success, response) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    self.dataSource![0].removeAll()
                    self.dataSource![1].removeAll()
                    let cars = response as! Array<CarCellInfoModel>
                    for car in cars {
                        if car.isCurrentCar == 0 {
                            self.dataSource![1].append(car)
                        }else{
                            TCUserInfo.currentInfo.currentCar = car.carnumber!
                            TCUserInfo.currentInfo.currentCarBrand = car.brand!
                            self.dataSource![0].append(car)
                        }
                    }
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showErrorWithStatus(response as! String)
                }
            })
        })
    }
    
    //MARK:------dataSource----
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return dataSource![0].count
        }else{
            return dataSource![1].count
        }
    }
    
    //MARK:-----delegate--------
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let cellModel = dataSource![indexPath.section][indexPath.row]
        let carDetailVC = TCCarDetailController(nibName: "TCCarDetailController",bundle: nil)
        carDetailVC.configureCarDetailWithModel(cellModel)
        carDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(carDetailVC, animated: true)
    }
    
    override func  tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView{
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        let carLabel = UILabel(frame: CGRectMake(30,10,100,20))
        carLabel.text = section == 0 ? "驾驶车辆" : "常用车辆"
        let imageView = UIImageView(frame: CGRectMake(5, 10, 20, 20))
        imageView.image = section == 0 ? UIImage(named:"ic_fangxiangpan") : UIImage(named:"ic_cheku")
        headerView.addSubview(carLabel)
        headerView.addSubview(imageView)
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CarInfoCell", forIndexPath: indexPath) as! CarInfoCell
        cell.setCellWithCarInfo(dataSource![indexPath.section][indexPath.row])
        
        return cell
    }
}
