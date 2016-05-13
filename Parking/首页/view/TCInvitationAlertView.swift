//
//  TCInvitationAlertView.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/25.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

protocol TCInvitationAlertViewDelegate:NSObjectProtocol{
    func invitationAlertSelectedButtonAtIndex(index:Int,_ model:TCContactorInfo?)
}

class TCInvitationAlertView: UIView {
    var contactorInfo : TCContactorInfo?
    
    @IBOutlet weak var sendTo: UILabel!
    
    func showAlertForModel(userInfo:TCContactorInfo){
        contactorInfo = userInfo
        sendTo.text = userInfo.userName
    }
    
    weak var delegate:TCInvitationAlertViewDelegate?
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        delegate?.invitationAlertSelectedButtonAtIndex(0,contactorInfo)
    }
    @IBAction func confirmButtonClicked(sender: AnyObject) {
        delegate?.invitationAlertSelectedButtonAtIndex(1,contactorInfo)
    }
}
