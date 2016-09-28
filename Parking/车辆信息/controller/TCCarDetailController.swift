//
//  TCCarDetailController.swift
//  Parking
//
//  Created by xiaocool on 16/4/26.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//
import UIKit

class TCCarDetailController: UIViewController,TCCarDetailPopViewDelegate,AddCarViewControllerDelegate {
    var showPopMenu:Bool?
    var popMenu:TCCarDetailPopView?
    var carid:String?
    var carModel:CarCellInfoModel?
    var carHelper = TCCarInfoHelper()
    var paymentHelper = TCPaymentHelper()
    
    @IBOutlet weak var carBrand: UILabel!
    @IBOutlet weak var carNumber: UILabel!
    @IBOutlet weak var carType: UILabel!
    @IBOutlet weak var engineNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPopMenu = false
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        //nav
        showforModel(carModel)
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showforModel(carModel)
    }
    
    func showforModel(model:CarCellInfoModel?){
        if carModel != nil {
            carBrand.text = carModel!.brand
            carNumber.text = carModel!.carnumber
            carType.text = carModel!.cartype
            engineNumber.text = carModel!.enginenumber
            carid = String(carModel!.carid!)
        }
    }
    
    func rightNavBtnClicked(){
        if showPopMenu == false {
            popMenu = NSBundle.mainBundle().loadNibNamed("TCCarDetailPopView", owner: nil, options: nil).first as? TCCarDetailPopView
            popMenu?.isCurrentCar = carModel?.isCurrentCar == 1
            let popX = self.view.frame.width-130
            popMenu!.frame = CGRectMake(popX, 0, 125, 160)
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
    
    func backToHomeWithReload(){
        self.navigationController?.popViewControllerAnimated(true)
        NSNotificationCenter.defaultCenter().postNotificationName(LOAD_CARINFO, object: nil)
    }
    
    func changedModel(model: CarCellInfoModel) {
        showforModel(model)
    }
    
    // MARK:----popViewDelegate----
    func selectPopView(popView: TCCarDetailPopView, index: Int) {
        rightNavBtnClicked()
        if index == 0 {
            let editVC = AddCarViewController(nibName: "AddCarViewController",bundle: nil)
            editVC.viewType = .edit
            editVC.configureWithcarModel(carModel!)
            editVC.delegate = self
            navigationController?.pushViewController(editVC, animated: true)
        }else if index == 1{
            print("车辆信息页面删除")
            carHelper.unBindCarWithCarNumber(carNumber.text!, handle: { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        SVProgressHUD.showSuccessWithStatus("删除成功")
                        if self.carModel?.isCurrentCar == 1{
                            TCUserInfo.currentInfo.currentCarBrand = ""
                            TCUserInfo.currentInfo.currentCar = ""
                        }
                        self.backToHomeWithReload()
                    }else {
                        SVProgressHUD.showErrorWithStatus(response as? String)
                    }
                })
            })
        } else{
            if carModel?.isCurrentCar == 0 {
                print("设为当前车辆")
                self.carHelper.upDateCurrentCarWithCarNumber(self.carNumber.text!, handle: {[unowned self] (success, response) in
                    dispatch_async(dispatch_get_main_queue(), {
                        if success {
                            SVProgressHUD.showSuccessWithStatus("修改成功")
                            self.backToHomeWithReload()
                        }else {
                            SVProgressHUD.showErrorWithStatus("修改失败")
                        }
                    })
                })
            }else{
                self.carHelper.upDateCurrentCarWithCarNumber("", handle: { (success, response) in
                    dispatch_async(dispatch_get_main_queue(), {
                        if success {
                            SVProgressHUD.showSuccessWithStatus("修改成功")
                            TCUserInfo.currentInfo.currentCar = ""
                            TCUserInfo.currentInfo.currentCarBrand = ""
                            self.backToHomeWithReload()
                        }else {
                            SVProgressHUD.showErrorWithStatus(response as? String)
                        }
                    })
                })
            }
        }
    }
}
