//
//  TCInvitationController.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/20.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import AddressBook
import AddressBookUI

class TCInvitationController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,TCInvitationAlertViewDelegate {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var personTableView: UITableView!
    var addbook : ABAddressBookRef?
    var dataSource : Dictionary<String,Array<TCContactorInfo>>?
    var keyChars:Array<String>?
    var alertBackGroundView:UIButton?
    var alertView:TCInvitationAlertView?
    var hasRight:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDataSource()
        configureUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !hasRight {
            SVProgressHUD.showErrorWithStatus("请打开程序通讯录权限")
        }
    }
    
    func configureUI(){
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        personTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "mailCell")
        personTableView.sectionIndexColor = UIColor(red: 61/255.0, green: 186/255.0, blue: 124/255.0, alpha: 1)
        personTableView.tableFooterView = UIView()
        //searchbar
        searchBar.setImage(UIImage(named: "ic_sousuo"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        let  textFieldInsideSearchBar=searchBar.valueForKey("searchField")as?UITextField
        
        textFieldInsideSearchBar?.textColor = UIColor(red: 61/255.0, green: 186/255.0, blue: 124/255.0, alpha: 1)
        
        let textFieldInsideSearchBarLabel=textFieldInsideSearchBar!.valueForKey("placeholderLabel")as?UILabel
        
        textFieldInsideSearchBarLabel?.textColor=UIColor(red: 61/255.0, green: 186/255.0, blue: 124/255.0, alpha: 1)
        //nav
        self.title = "邀请好友"
        let navBtn = UIButton(type: .Custom)
        navBtn.frame = CGRectMake(0, 0, 30, 30)
        navBtn.setImage(UIImage(named: "ic_fanhui-left"), forState: .Normal)
        navBtn.addTarget(self, action: #selector(backToHome), forControlEvents: .TouchUpInside)
        let navItem = UIBarButtonItem(customView: navBtn)
        self.navigationItem.leftBarButtonItem = navItem
    }
    
    func addAlertViewForModel(model:TCContactorInfo){
        //alert
        let keywin = UIApplication.sharedApplication().keyWindow
        alertBackGroundView = UIButton(type: UIButtonType.Custom)
        alertBackGroundView!.backgroundColor = UIColor.blackColor()
        alertBackGroundView!.alpha = 0.4
        alertBackGroundView!.frame = keywin!.bounds
        alertBackGroundView!.addTarget(self, action:#selector(BackgroundBtnClicked), forControlEvents: UIControlEvents.TouchUpInside)
        keywin?.addSubview(alertBackGroundView!)
        let viewWidth = keywin!.bounds.width*0.6
        let viewHeight = keywin!.bounds.height*0.2
        let viewX = keywin!.bounds.width*0.2
        let viewY = keywin!.bounds.height*0.4
        alertView = NSBundle.mainBundle().loadNibNamed("TCInvitationAlertView", owner: nil, options: nil).first as? TCInvitationAlertView
        alertView?.showAlertForModel(model)
        alertView!.frame = CGRectMake(viewX,viewY,viewWidth,viewHeight)
        alertView?.layer.cornerRadius = 4
        alertView?.delegate = self
        keywin?.addSubview(alertView!)
    }
    
    func BackgroundBtnClicked(){
        alertBackGroundView?.removeFromSuperview()
        alertView?.removeFromSuperview()
    }
    
    func makeDataSource(){
        //处理通讯录信息
        let userInfoDics = getSysContacts()
        dataSource = [:]
        var models:[TCContactorInfo] = []
        //获取全名
        for userInfo in userInfoDics {
            let contactor = TCContactorInfo()
            let username = userInfo["FirstName"]! + userInfo["LastName"]!
            let phoneNum = userInfo["PhoneNumber"]
            contactor.phoneNumber = phoneNum
            contactor.userName = username
            models.append(contactor)
        }
        keyChars = []
        for person in models {
            //获取首字母
            let firstChar = TCChangeWord().firstCharactor(person.userName!)
            //生成source字典
            if keyChars!.contains(firstChar) {
                dataSource?[firstChar]?.append(person)
            }else{
                keyChars!.append(firstChar)
                var personArray:[TCContactorInfo] = []
                personArray.append(person)
                //生成新的首字母数组
                dataSource?[firstChar] = personArray
            }
        }
        keyChars?.sortInPlace()
    }
    
    func backToHome(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    //获取通讯录信息
    func getSysContacts() -> [[String:String]] {
        var error:Unmanaged<CFError>?
        let addressBook: ABAddressBookRef? = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
        let sysAddressBookStatus = ABAddressBookGetAuthorizationStatus()
        
        if sysAddressBookStatus == .NotDetermined {
            // Need to ask for authorization
            let authorizedSingal:dispatch_semaphore_t = dispatch_semaphore_create(0)
            let askAuthorization:ABAddressBookRequestAccessCompletionHandler = {[unowned self] success, error in
                dispatch_semaphore_signal(authorizedSingal)
                if success {
                    ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray
                }else{
                    self.hasRight = false
                }
            }
            ABAddressBookRequestAccessWithCompletion(addressBook, askAuthorization)
            dispatch_semaphore_wait(authorizedSingal, DISPATCH_TIME_FOREVER)
        }
        if  !hasRight{
            return [[:]]
        }
        return analyzeSysContacts( ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray )
    }
    func analyzeSysContacts(sysContacts:NSArray) -> [[String:String]] {
        var allContacts:Array = [[String:String]]()
        for contact in sysContacts {
            var currentContact:Dictionary = [String:String]()
            // 姓
            currentContact["FirstName"] = ABRecordCopyValue(contact, kABPersonFirstNameProperty)?.takeRetainedValue() as! String? ?? ""
            // 名
            currentContact["LastName"] = ABRecordCopyValue(contact, kABPersonLastNameProperty)?.takeRetainedValue() as! String? ?? ""
            // 昵称
            currentContact["Nikename"] = ABRecordCopyValue(contact, kABPersonNicknameProperty)?.takeRetainedValue() as! String? ?? ""
            let phoneValues:ABMutableMultiValueRef? =
                ABRecordCopyValue(contact, kABPersonPhoneProperty).takeRetainedValue()
            if phoneValues != nil {
                var phoneNums:[String] = []
                print("电话：")
                for i in 0 ..< ABMultiValueGetCount(phoneValues){
                    // 获得标签名
                    let phoneLabel = ABMultiValueCopyLabelAtIndex(phoneValues, i).takeRetainedValue()
                        as CFStringRef;
                    // 转为本地标签名（能看得懂的标签名，比如work、home）
                    let localizedPhoneLabel = ABAddressBookCopyLocalizedLabel(phoneLabel)
                        .takeRetainedValue() as String
                    
                    let value = ABMultiValueCopyValueAtIndex(phoneValues, i)
                    let phone = value.takeRetainedValue() as! String
                    phoneNums.append(phone)
                    print("\(localizedPhoneLabel):\(phone)")
                }
                currentContact["PhoneNumber"] = phoneNums.first
            }
            allContacts.append(currentContact)
        }
        return allContacts
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataSource![keyChars![section]]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("mailCell")
        let names = dataSource![keyChars![indexPath.section]]
        cell?.textLabel?.text = names![indexPath.row].userName
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        addAlertViewForModel(dataSource![keyChars![indexPath.section]]![indexPath.row])
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return keyChars![section]
    }
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]?{
        return keyChars
    }
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return dataSource!.keys.count
    }
    func scrollViewDidScroll(scrollView: UIScrollView){
        self.view.endEditing(true)
    }
    // MARK:--TCInvitationAlertViewDelegate---
    func invitationAlertSelectedButtonAtIndex(index:Int,_ model:TCContactorInfo?){
        //cancel
        if index == 0 {
            print("取消")
            BackgroundBtnClicked()
        }else{ //confirm
            print("确认,发送短信给"+String(model!.phoneNumber!))
            BackgroundBtnClicked()
        }
    }
}
