//
//  JBridgeProtocol.swift
//  JBridge
//
//  Created by HeJeffery on 2017/4/27.
//  Copyright © 2017年 HeJeffery. All rights reserved.
//

import Foundation
import JavaScriptCore

/** 
 JBridgeProtocol protocol
*/
@objc public protocol JBridgeProtocol: JSExport {

    func showAlert(_ title: String, message: String, left: String, right: String)
    
    func showActionSheet(_ title: String, destructive: String, others: [String])
    
    func fetchUUID() -> String
    
    func fetchVendor() -> String
    
    func fetchModel() -> String
    
    func fetchSystemVersion() -> String
    
    func fetchSystemName() -> String
    
    func call(_ number: String)
    
    func sendSms(_ number: String)
    
    func sendMail(_ mail: String)
    
    func flashlight()
    
    func locationInfo()
}
