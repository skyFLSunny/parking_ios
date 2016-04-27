//
//  TCCarInfoController.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/17.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCCarInfoController: UITableViewController {
    var dataSource:Array<Array<TCCarInfoModel>>?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = false
        makeDataSource()
        self.tableView.registerNib(UINib.init(nibName: "CarInfoCell", bundle: nil), forCellReuseIdentifier: "CarInfoCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
    }
    func makeDataSource(){
        dataSource = [[],[]];
        for index in 0...10 {
            let carInfo = TCCarInfoModel()
            carInfo.setCarInfoModel("鲁F"+String(88888+index), carBrand: "宝马", carOwner: "user"+String(index), carId: String(index), engineNumber: "666", driving: index%2 == 0, brandImageUrl: "wwww.baidu.com")
            if carInfo.driving == true {
                dataSource![0].append(carInfo)
            }else{
                dataSource![1].append(carInfo)
            }
        }
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
        let carDetailVC = TCCarDetailController(nibName: "TCCarDetailController",bundle: nil)
        carDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(carDetailVC, animated: true)
    }

    override func  tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView{
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        let carLabel = UILabel(frame: CGRectMake(30,10,100,20))
        carLabel.text = section == 0 ? "驾驶车辆" : "常用车库"
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
