//
//  TCChangeWord.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/20.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class TCChangeWord: NSObject {
    
    func charactorType(textString:String) -> Int{
        
        let char = textString.substringToIndex(textString.startIndex.advancedBy(1))
        
        let eRegex: String = "^[a-zA-z]+$"
        let eTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", eRegex)
        if eTest.evaluateWithObject(char){
            return 1
        }
        let zRegex: String = "^[\\u4e00-\\u9fa5]"
        let zTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", zRegex)
        
        if zTest.evaluateWithObject(char){
            return 2
        }
        return 0
    }
    func firstCharactor(aString:String) -> String{
        let stringType = charactorType(aString)
        if stringType == 1 {
            return aString.substringToIndex(aString.startIndex.advancedBy(1))
        }else if stringType == 2 {
        //转成了可变字符串
        let str = NSMutableString(string: aString)
        //先转换为带声调的拼音
        CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false)
        //再转换为不带声调的拼音
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)
        //转化为大写拼音
        let pinYin = str.capitalizedString
        //获取并返回首字母
            return pinYin.substringToIndex(pinYin.startIndex.advancedBy(1))
        }
        return " "
        
    }
}
