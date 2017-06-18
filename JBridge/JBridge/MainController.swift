//
//  MainController.swift
//  JBridge
//
//  Created by HeJeffery on 2017/4/22.
//  Copyright © 2017年 HeJeffery. All rights reserved.
//

import UIKit
import JavaScriptCore

class MainController: UIViewController {
    
    fileprivate var jsContext: JSContext?
    
    private lazy var webView: UIWebView = {
        
        let webView = UIWebView()
        webView.delegate = self
        
        let path = Bundle.main.path(forResource: "main.html", ofType: nil)
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

// MARK: UIWebViewDelegate
extension MainController: UIWebViewDelegate {
    
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
        
        // 注入JBridge模型
        let jbridge = JBridge()
        jbridge.jsContext = jscontext
        jbridge.controller = self
        jbridge.webView = webView
        // JS可以通过"jbridge"这个引用调用JBridge实例中的方法
        jscontext.setObject(jbridge, forKeyedSubscript: "jbridge" as (NSCopying & NSObjectProtocol)!)
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("------shouldStartLoadWith------")
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("------加载失败------")
    }
}
