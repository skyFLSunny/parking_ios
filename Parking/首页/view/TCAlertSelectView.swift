//
//  TCAlertSelectView.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/18.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
protocol TCAlertSelectViewDelegate:NSObjectProtocol {
    func cancelButtonClicked()
    func tureButtonClicked(carinfos:Array<TCCarInfoModel>?)
}
class TCAlertSelectView: UIView,UITableViewDelegate,UITableViewDataSource {
    var headerView:UIView?
    var selectTableView:UITableView?
    weak var delegate:TCAlertSelectViewDelegate?
    var bottomView:UIView?
    ///所有车辆
    var dataSource:Array<TCCarInfoModel>?
    ///已选择的车辆
    var selectedCars:Array<TCCarInfoModel>?
    ///是否全部选中
    var isAllSelect:Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeDataSource()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    override func layoutSubviews() {
        self.backgroundColor = UIColor.whiteColor()
        addheaderView()
        addTableView()
        addBottomView()
    }
    func makeDataSource(){
        dataSource = []
        selectedCars = []
        for index in 0...5 {
            let carInfo = TCCarInfoModel()
            carInfo.carNumber = "鲁Y"+String(88888+index)
            carInfo.isSelected = false
            dataSource?.append(carInfo)
        }
    }
    func addheaderView(){
        headerView = UIView(frame: CGRectMake(0,0,self.frame.width,self.frame.height*0.16))
        let titleLabel = UILabel(frame: CGRectMake(5,10,100,20))
        titleLabel.text = "请选择缴费车辆"
        titleLabel.font = UIFont.systemFontOfSize(12)
        let allSelect = UIButton(type: .Custom)
        allSelect.setTitle("全选", forState: .Normal)
        allSelect.titleLabel?.font = UIFont.systemFontOfSize(12)
        allSelect.setTitleColor(UIColor(red: 61/255.0, green: 186/255.0, blue: 124/255.0, alpha: 1), forState: .Normal)
        allSelect.frame = CGRectMake(self.frame.width*0.8, 10, self.frame.width*0.15, 20)
        allSelect.addTarget(self, action: #selector(allSelectButtonClicked), forControlEvents: .TouchUpInside)
        let lineLabel = UILabel(frame: CGRectMake(0,headerView!.frame.height*0.8,headerView!.frame.width,headerView!.frame.height*0.2))
        lineLabel.text = "...................................................................................................................................................."
        lineLabel.textColor = UIColor(red: 61/255.0, green: 186/255.0, blue: 124/255.0, alpha: 1)
        lineLabel.font = UIFont.systemFontOfSize(10)
        headerView!.addSubview(titleLabel)
        headerView!.addSubview(allSelect)
        headerView!.addSubview(lineLabel)
        self.addSubview(headerView!)
    }
    
    func addTableView(){
        selectTableView = UITableView(frame: CGRectMake(0,self.frame.height*0.16,self.frame.width,self.frame.height*0.6))
        selectTableView?.separatorStyle = .None
        selectTableView?.registerNib(UINib.init(nibName: "TCHomeAlertTableCell", bundle: nil), forCellReuseIdentifier: "alertCell")
        selectTableView?.delegate = self
        selectTableView?.dataSource = self
        self.addSubview(selectTableView!)
    }
    func addBottomView(){
        bottomView = UIView(frame: CGRectMake(0,self.frame.height*0.76,self.frame.width,self.frame.height*0.24))
        let cancelBtn = UIButton(type: .Custom)
        let tureBtn = UIButton(type: .Custom)
        let viewWidth = self.frame.width
        let btnWidth = viewWidth*0.35
        let viewY = bottomView!.frame.height*0.21
        let btnHeight = bottomView!.frame.height*0.48
        
        cancelBtn.frame = CGRectMake(viewWidth*0.1,viewY , btnWidth, btnHeight)
        tureBtn.frame = CGRectMake(viewWidth*0.55, viewY, btnWidth, btnHeight)
        
        cancelBtn.setTitle("取消", forState: .Normal)
        tureBtn.setTitle("确认", forState: .Normal)
        
        cancelBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        tureBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        cancelBtn.layer.cornerRadius = 4
        tureBtn.layer.cornerRadius = 4
        
        cancelBtn.backgroundColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1)
        tureBtn.backgroundColor = UIColor(red: 61/255.0, green: 186/255.0, blue: 124/255.0, alpha: 1)
        cancelBtn.addTarget(self, action: #selector(cancelButtonClicked), forControlEvents: .TouchUpInside)
        tureBtn.addTarget(self, action: #selector(tureButtonClicked), forControlEvents: .TouchUpInside)
        
        bottomView?.addSubview(cancelBtn)
        bottomView?.addSubview(tureBtn)
        self .addSubview(bottomView!)
    }
    func allSelectButtonClicked(){
        if isAllSelect == true {
            for carInfo in dataSource! {
                carInfo.isSelected = false
                selectedCars?.removeAll()
            }
            isAllSelect = false
        }else{
            for carInfo in dataSource! {
                carInfo.isSelected = true
                selectedCars?.append(carInfo)
            }
            isAllSelect = true
        }
        selectTableView?.reloadData()
        
    }
    func cancelButtonClicked(){
        self.delegate?.cancelButtonClicked()
    }
    func tureButtonClicked(){
        self.delegate?.tureButtonClicked(selectedCars)
    }
    // MARK:-----tableViewDataSource-------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataSource!.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if dataSource![indexPath.row].isSelected! {
            dataSource![indexPath.row].isSelected = false
            selectedCars?.removeAtIndex(selectedCars!.indexOf(dataSource![indexPath.row])!)
        }else{
            dataSource![indexPath.row].isSelected = true
            selectedCars?.append(dataSource![indexPath.row])
        }
        tableView.reloadData()
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("alertCell") as!TCHomeAlertTableCell
        cell.setCellWithCarInfo(dataSource![indexPath.row])
        return cell
    }
}
