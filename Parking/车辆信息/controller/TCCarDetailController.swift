//
//  TCCarDetailController.swift
//  Parking
//
//  Created by xiaocool on 16/4/26.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCCarDetailController: UIViewController,TCCarDetailPopViewDelegate {
    var showPopMenu:Bool?
    var popMenu:TCCarDetailPopView?
    var carid:String?
    var carModel:CarCellInfoModel?
    
    @IBOutlet weak var carBrand: UILabel!
    @IBOutlet weak var carNumber: UILabel!
    @IBOutlet weak var carType: UILabel!
    @IBOutlet weak var engineNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPopMenu = false
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        if carModel != nil {            
            carBrand.text = carModel!.brand
            carNumber.text = carModel!.carnumber
            carType.text = carModel!.cartype
            engineNumber.text = carModel!.enginenumber
            carid = String(carModel!.carid!)
        }
        //nav
        self.title = "车辆信息"
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
        let rightButton = UIButton(type: .Custom)
        rightButton.frame = CGRectMake(0, 0, 30, 30)
        rightButton.setImage(UIImage(named: "ic_gengduoyoushang"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(rightNavBtnClicked), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton)
    }
    func rightNavBtnClicked(){
        if showPopMenu == false {
            popMenu = NSBundle.mainBundle().loadNibNamed("TCCarDetailPopView", owner: nil, options: nil).first as? TCCarDetailPopView
            let popX = self.view.frame.width-130
            popMenu!.frame = CGRectMake(popX, 0, 125, 100)
            popMenu!.backgroundColor = UIColor.clearColor()
            popMenu!.delegate = self
            self.view.addSubview(popMenu!)
            showPopMenu = true
        }else{
            popMenu?.removeFromSuperview()
            popMenu = nil
            showPopMenu = false
        }
    }
    
    func configureCarDetailWithModel(Model:CarCellInfoModel){
        carModel = Model
    }
    
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    // MARK:----popViewDelegate----
    func selectPopView(popView: TCCarDetailPopView, index: Int) {
        rightNavBtnClicked()
        if index == 0 {
            let editVC = AddCarViewController(nibName: "AddCarViewController",bundle: nil)
            editVC.viewType = .edit
            editVC.configureWithbrand(carBrand.text, myCarNumber: carNumber.text, myCarType:carType.text, myEngineNum: engineNumber.text,myCarid:carid)
            navigationController?.pushViewController(editVC, animated: true)
        }else{
            print("车辆信息页面删除")
        }
    }
}
