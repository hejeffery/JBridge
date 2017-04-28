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

    static func showAlert(_ title: String, message: String)
}
