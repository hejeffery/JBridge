//
//  JBridge.swift
//  JBridge
//
//  Created by jhe.jeffery on 2017/5/2.
//  Copyright © 2017年 HeJeffery. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore
import FCUUID

class JBridge: NSObject, JBridgeProtocol {
    
    weak var jsContext: JSContext?
    
    weak var controller: UIViewController?
    
    func showAlert(_ title: String, message: String, left: String, right: String) {

        DispatchQueue.main.async {
            let alertView = UIAlertView.init(title: title == "null" ? "提示" : title,
                                             message: message,
                                             delegate: nil,
                                             cancelButtonTitle: left == "null" ? "取消" : left,
                                             otherButtonTitles: right == "null" ? "确定" : right)
            
            alertView.show()
        }
    }
    
    func showActionSheet(_ title: String, destructive: String, others: [String]) {
        
        DispatchQueue.main.async {
            let actionSheet = UIActionSheet.init(title: title == "null" ? "提示" : title,
                                                 delegate: nil,
                                                 cancelButtonTitle: "取消",
                                                 destructiveButtonTitle: destructive == "null" ? nil : destructive)
            
            for item in others {
                actionSheet.addButton(withTitle: item)
            }
            
            guard let controller = self.controller else {
                return
            }
            actionSheet.show(in: controller.view)
        }
    }
    
    func fetchUUID() -> String {
        return UIDevice.current.uuid()
    }
    
    func fetchVendor() -> String {
        return FCUUID.uuidForVendor()
    }
    
    func fetchModel() -> String {
        return UIDevice.current.model
    }
    
    func fetchSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    func fetchSystemName() -> String {
        return UIDevice.current.systemName
    }
}
