//
//  TCCarDetailPopView.swift
//  Parking
//
//  Created by xiaocool on 16/5/9.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

protocol TCCarDetailPopViewDelegate:NSObjectProtocol {
    func selectPopView(popView:TCCarDetailPopView,index:Int)
}

class TCCarDetailPopView: UIView {
    
    weak var delegate :TCCarDetailPopViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("弹出框")
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }

    override func drawRect(rect: CGRect) {
        //background
        UIColor.whiteColor().set()
        //draw Angle
        let context = UIGraphicsGetCurrentContext()
        //path tag
        CGContextBeginPath(context)
        let locationX = self.frame.width - 15
        CGContextMoveToPoint(context,locationX,10)
        CGContextAddLineToPoint(context,locationX - 10,0)
        CGContextAddLineToPoint(context,locationX - 20,10)
        //path end
        CGContextClosePath(context)
        //fill color
        UIColor.blackColor().setFill()
        //boder color
        UIColor.blackColor().setStroke()
        //draw
        CGContextDrawPath(context,CGPathDrawingMode.FillStroke)
    }
    @IBAction func deleteCarInfo(sender: AnyObject) {
        print("删除")
        delegate?.selectPopView(self, index: 1)
    }
    @IBAction func editCarInfo(sender: AnyObject) {
        print("编辑")
        delegate?.selectPopView(self, index: 0)
    }
    @IBAction func setCarToPresent(sender: AnyObject) {
        print("当前")
        delegate?.selectPopView(self, index: 2)
    }
}
