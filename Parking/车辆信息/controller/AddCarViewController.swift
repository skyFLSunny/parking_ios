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

class AddCarViewController: UIViewController,UIScrollViewDelegate {
    /// 车辆品牌
    @IBOutlet weak var ownerName: UITextField!
    /// 车牌号
    @IBOutlet weak var carNumber: UITextField!
    /// 车型
    @IBOutlet weak var carType: UITextField!
    /// 发动机号
    @IBOutlet weak var engineNum: UITextField!
    
    @IBOutlet weak var tpScrollView: TPKeyboardAvoidingScrollView!
    
    var brandStr:String?
    var carNumStr:String?
    var carTypeStr:String?
    var engineNumStr:String?
    
    var viewType:CarControllerType = .add
    
    var carInfoHelper:TCCarInfoHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        carInfoHelper = TCCarInfoHelper()
    }
    func configureWithbrand(mybrand:String,myCarNumber:String,myCarType:String,myEngineNum:String){
        brandStr = mybrand
        carNumStr = myCarNumber
        carTypeStr = myCarType
        engineNumStr = myEngineNum
    }
    func configureUI(){

        let gesture = UITapGestureRecognizer(target: self, action: #selector(hiddenKeyBoard))
        self.view.addGestureRecognizer(gesture)
        
        ownerName.layer.borderColor = UIColor.whiteColor().CGColor
        ownerName.layer.borderWidth = 1
        carNumber.layer.borderColor = UIColor.whiteColor().CGColor
        carNumber.layer.borderWidth = 1
        carType.layer.borderColor = UIColor.whiteColor().CGColor
        carType.layer.borderWidth = 1
        engineNum.layer.borderColor = UIColor.whiteColor().CGColor
        engineNum.layer.borderWidth = 1
        
        if viewType == .edit {
            ownerName.text = brandStr
            carNumber.text = carNumStr
            carType.text = carTypeStr
            engineNum.text = engineNumStr
        }
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.title = viewType == .add ? "添加车辆" : "修改车辆"
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
        if carType.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入车型")
            return
        }
        if engineNum.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入发动机号")
            return
        }
        if viewType == .add {
            
            carInfoHelper?.addCarWithOnwerID(ownerName.text!, carNumber: carNumber.text!, carType: carType.text!, engineNum: engineNum.text!, handle: { (success, response) in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {
                        SVProgressHUD.showSuccessWithStatus("添加成功")
                    }else{
                        SVProgressHUD.showErrorWithStatus(response as? String)
                    }
                })
            })
            
        }else{
            print("修改完成")
        }
        
//        navigationController?.popViewControllerAnimated(true)
    }
    func backToHome(){
        navigationController?.popViewControllerAnimated(true)
    }
    func hiddenKeyBoard(){
        self.view.endEditing(true)
    }
}
