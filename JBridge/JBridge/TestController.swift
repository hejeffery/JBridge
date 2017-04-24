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
        
        guard jsContext != nil else {
            return
        }
        jsContext!.exceptionHandler = { (context, exception) -> () in
            print("exception = \(String(describing: exception))")
        }
        
        // swift call JS
        swiftCallJS()
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
        jscontext.evaluateScript("function addMethod(num1, num2){ return num1 + num2 }")
        
        // 方式一：用js调用方法
        let addResult1 = jscontext.evaluateScript("addMethod(99, 11)")
        if let addResult1 = addResult1 {
            print("addResult1 = \(String(describing: addResult1.toNumber()))")
        }
        
        // 方式二：OC中调用js的调用
        let methodValue = jscontext.objectForKeyedSubscript("addMethod")
        guard let methodvalue = methodValue else {
            return
        }
        let addResult2 = methodvalue.call(withArguments: [99, 11])
        if let addResult2 = addResult2 {
            print("addResult2 = \(String(describing: addResult2.toNumber()))")
        }
        
    }
    
    func JSCallSwift() {
        
    }
    
}
