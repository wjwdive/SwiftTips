//
//  WJWPublic.swift
//  SwiftTips
//
//  Created by wjw on 2021/4/22.
//

import UIKit

func classFromStr(_ className:String) -> UIViewController{
      //Swift中命名空间的概念
    var name = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String
    name = name?.replacingOccurrences(of: "-", with: "_")
    let fullClassName = name! + "." + className
    guard let classType = NSClassFromString(fullClassName) as? UIViewController.Type  else{
        fatalError("转换失败")
    }
    return classType.init()
}

class WJWPublic: NSObject {

}
