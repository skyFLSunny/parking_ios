//
//  AddCarViewController.swift
//  Parking
//  Created by xiaocool on 16/5/13.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

enum CarControllerType {
    case add
    case edit
}

protocol AddCarViewControllerDelegate:NSObjectProtocol {
    func changedModel(model:CarCellInfoModel)
}

class AddCarViewController: UIViewController,UIScrollViewDelegate,UIAlertViewDelegate {
    /// 车辆品牌
    @IBOutlet weak var ownerName: UITextField!
    /// 车牌号
    @IBOutlet weak var carNumber: UITextField!
    /// 车型
    @IBOutlet weak var carType: UIButton!
    /// 发动机号
    @IBOutlet weak var engineNum: UITextField!
    
    @IBOutlet weak var tpScrollView: TPKeyboardAvoidingScrollView!
    
    weak var delegate:AddCarViewControllerDelegate?
    
    var carModel:CarCellInfoModel?
    
    var viewType:CarControllerType = .add
    
    var carInfoHelper:TCCarInfoHelper?
    
    var alertControl:UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        carInfoHelper = TCCarInfoHelper()
        carType.addTarget(self, action: #selector(selectCarType), forControlEvents: .TouchUpInside)
        alertControl = UIAlertController(title: nil, message: "是否设置为当前驾驶车辆？", preferredStyle: .Alert)
        alertControl?.addAction(UIAlertAction(title: "是", style: .Default, handler: { (alertAction) in
            self.carInfoHelper?.upDateCurrentCarWithCarNumber(self.carNumber.text!, handle: {[unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        SVProgressHUD.showSuccessWithStatus("设置成功")
                        self.backToHomeWithReload()
                    }else {
                        SVProgressHUD.showErrorWithStatus(response as? String)
                        self.backToHomeWithReload()
                    }
                })
                })
        }))
        alertControl?.addAction(UIAlertAction(title: "否", style: .Cancel, handler: { (alert) in
            dispatch_async(dispatch_get_main_queue(), {
                self.backToHomeWithReload()
            })
        }))
    }
    
    func selectCarType(){
        let alert = UIAlertView(title: "请选择车型", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "小型车", "中型车", "大型车")
        
        alert.show()
    }
    
    func configureWithcarModel(model:CarCellInfoModel){
        carModel = model
    }
    
    func configureUI(){
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hiddenKeyBoard))
        self.view.addGestureRecognizer(gesture)
        
        ownerName.layer.borderColor = UIColor.whiteColor().CGColor
        ownerName.layer.borderWidth = 2
        carNumber.layer.borderColor = UIColor.whiteColor().CGColor
        carNumber.layer.borderWidth = 2
        carType.layer.borderColor = UIColor.whiteColor().CGColor
        carType.layer.borderWidth = 2
        engineNum.layer.borderColor = UIColor.whiteColor().CGColor
        engineNum.layer.borderWidth = 2
        
        if viewType == .edit {
            ownerName.text = carModel?.brand
            carNumber.text = carModel?.carnumber
            carType.setTitle(carModel?.cartype, forState: .Normal)
            engineNum.text = carModel?.enginenumber
        }
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = viewType == .add ? "添加车辆" : "修改车辆"
        if viewType == .edit {
            carNumber.userInteractionEnabled = false
            carNumber.textColor = UIColor.lightGrayColor()
        }
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
        
        let rightNavBtn = UIButton(type: .Custom)
        rightNavBtn.frame = CGRectMake(0, 0, 60, 30)
        rightNavBtn.setTitle("完成", forState: .Normal)
        rightNavBtn.addTarget(self, action: #selector(complete), forControlEvents: .TouchUpInside)
        let rightItem = UIBarButtonItem(customView: rightNavBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func complete(){
        
        print("完成")
        
        if ownerName.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入车辆品牌")
            return
        }
        
        if carNumber.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入车牌号")
            return
        }
        
        if engineNum.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入发动机号")
            return
        }
        
        if viewType == .add {
            SVProgressHUD.show()
            carInfoHelper?.addCarWithOnwerID(ownerName.text!, carNumber: carNumber.text!, carType: carType.titleLabel!.text!, engineNum: engineNum.text!, handle: { [unowned self] (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    SVProgressHUD.showSuccessWithStatus("添加成功")
                    if success {
                        self.presentViewController(self.alertControl!, animated: true, completion: nil)
                    }else{
                        SVProgressHUD.showErrorWithStatus(response as? String)
                    }
                })
            })
        }else{
            carInfoHelper?.editCarInfoWithCarID(String((carModel?.carid)!), carNumber:carNumber.text!, brand:  ownerName.text!, userid:TCUserInfo.currentInfo.userid, cartype:carType.titleLabel!.text!, engineNum: engineNum.text!, handle: { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        self.carModel?.brand = self.ownerName.text!
                        self.carModel?.carnumber = self.carNumber.text!
                        self.carModel?.cartype = self.carType.titleLabel!.text
                        self.carModel?.enginenumber = self.engineNum.text!
                        SVProgressHUD.showSuccessWithStatus("修改成功")
                        self.backToHomeWithReload()
                        self.delegate?.changedModel(self.carModel!)
                    }else{
                        SVProgressHUD.showErrorWithStatus(response as? String)
                    }
                })
            })
        }
    }
    
    func backToHome(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if buttonIndex == 0 {
            return
        }
        carType.setTitle(alertView.buttonTitleAtIndex(buttonIndex), forState: .Normal)
    }
    
    func backToHomeWithReload(){
        navigationController?.popViewControllerAnimated(true)
        NSNotificationCenter.defaultCenter().postNotificationName(LOAD_CARINFO, object: nil)
    }
    
    func backWithLoadModel(model:CarCellInfoModel){
        navigationController?.popViewControllerAnimated(true)
        NSNotificationCenter.defaultCenter().postNotificationName(LOAD_CARINFO, object: model)
    }
    
    func hiddenKeyBoard(){
        self.view.endEditing(true)
    }
}