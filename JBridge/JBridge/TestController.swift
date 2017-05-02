//
//  TestController.swift
//  JBridge
//
//  Created by HeJeffery on 2017/4/22.
//  Copyright © 2017年 HeJeffery. All rights reserved.
//

import UIKit
import JavaScriptCore

class TestController: UIViewController {
    
    fileprivate var jsContext: JSContext?

    private lazy var webView: UIWebView = {

        let webView = UIWebView()
        webView.delegate = self
        
        let path = Bundle.main.path(forResource: "test.html", ofType: nil)
        if let path = path {
            let url = URL(fileURLWithPath: path)
            let request = URLRequest(url: url)
            webView.loadRequest(request);
        }
        return webView

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.frame = view.frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TestController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("------开始加载------")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("------加载结束------")
        title = webView.stringByEvaluatingJavaScript(from: "document.title")
        
        // 禁用用户选择
        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitUserSelect='none';")
        // 禁用长按弹出框
        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitTouchCallout='none';")
        
        jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        
        guard let jscontext = jsContext else {
            return
        }

        jscontext.exceptionHandler = { (context, exception) -> () in
            print("exception = \(String(describing: exception))")
        }
        
//        // swift call JS
//        swiftCallJS()
        
        // JS call swift
        JSCallSwift()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("------shouldStartLoadWith------")
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("------加载失败------")
    }
    
    // MARK: Test Method
    func swiftCallJS() {
        
        guard let jscontext = jsContext else {
            return
        }
        // 方法调用：
//        jscontext.evaluateScript("function addMethod(num1, num2){ return num1 + num2 }")
//        // 方式一：用js调用方法
//        let addResult1 = jscontext.evaluateScript("addMethod(99, 11)")
//        if let addResult1 = addResult1 {
//            print("addResult1 = \(String(describing: addResult1.toNumber()))")
//        }
//        
//        // 方式二：OC中调用js的调用
//        let methodValue = jscontext.objectForKeyedSubscript("addMethod")
//        guard let methodvalue = methodValue else {
//            return
//        }
//        let addResult2 = methodvalue.call(withArguments: [99, 11])
//        if let addResult2 = addResult2 {
//            print("addResult2 = \(String(describing: addResult2.toNumber()))")
//        }
        
        // 变量的使用：
        jscontext.evaluateScript("var num1 = 9")
        jscontext.evaluateScript("var num2 = 18")
        jscontext.evaluateScript("var result = num1 + num2")
        let result = jscontext.objectForKeyedSubscript("result")
        guard let addResult = result else {
            return
        }
        print("result = \(String(describing: addResult.toNumber()))")

    }
    
    func JSCallSwift() {
        
        guard let jscontext = jsContext else {
            return
        }
        
        // 第一种方式：block/closure
        // 第一步：创建一个类型是@convention(block) (type) -> (type)的block/closure.这其实就是js调用swift后的执行block/closure
        // 第二步：使用unsafeBitCast转换类型
        // 第三步：使用jscontext.setObject(alertViewObject, forKeyedSubscript: "showAlertView" as (NSCopying & NSObjectProtocol))
        
        // show alertView
        let showAlert: @convention(block) () -> () = {
            let alertView = UIAlertView.init(title: "AlertView",
                                             message: "JS Call Swift",
                                             delegate: nil,
                                             cancelButtonTitle: "取消",
                                             otherButtonTitles: "确定")
            
            alertView.show()
        }
        let alertViewObject = unsafeBitCast(showAlert, to: AnyObject.self)
        // 这里的showAlertView是在js中的
        jscontext.setObject(alertViewObject, forKeyedSubscript: "showAlertView" as (NSCopying & NSObjectProtocol)!)
        
        // show ActionSheet
        let showActionSheet: @convention(block) () -> () = {
            let actionSheet = UIActionSheet.init(title: "ActionSheet",
                                                 delegate: nil,
                                                 cancelButtonTitle: "Cancel",
                                                 destructiveButtonTitle: "destructive",
                                                 otherButtonTitles: "other")
            
            actionSheet.show(in: self.view)
        }
        let actionSheetObject = unsafeBitCast(showActionSheet, to: AnyObject.self)
        jscontext.setObject(actionSheetObject, forKeyedSubscript: "showActionSheet" as (NSCopying & NSObjectProtocol)!)
        
    }
}
