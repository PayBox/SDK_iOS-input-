

//
//  WebController.swift
//  PayBoxSdk
//
//  Created by Arman Mergenbayev on 24.11.2017.
//  Copyright © 2017 paybox. All rights reserved.
//

import UIKit

class WebController: UIViewController, UIWebViewDelegate {
    var webUrl: String = String()
    var helper: PBHelper
    var webView: UIWebView!
    var customer: String?
    public var operation: PBHelper.OPERATION
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    public init(url: String, helper: PBHelper, operation: PBHelper.OPERATION) {
        self.webUrl = url
        self.helper = helper
        self.operation = operation
        if url.range(of: Constants.CUSTOMER) != nil {
            self.customer = url.components(separatedBy: Constants.CUSTOMER)[1]
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initToolbar(){
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        toolbar.sizeToFit()
        toolbar.backgroundColor = UIColor.blue
        let cancel = UIBarButtonItem.init(title: Constants.CANCEL_WEBVIEW, style: UIBarButtonItemStyle.plain, target: self, action: #selector(exit))
        toolbar.setItems([cancel], animated: true)
        self.view.addSubview(toolbar)
    }
    @objc private func exit(){
        self.dismiss(animated: true, completion: nil)
        helper.webSubmited(operation: operation, isSuccess: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        webView = UIWebView.init(frame: CGRect.init(x: 0, y: 40, width: self.view.bounds.width, height: self.view.bounds.height))
        webView.contentMode = .scaleAspectFit
        self.view.addSubview(webView)
        initToolbar()
        webView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        webView.loadRequest(URLRequest(url: URL(string: webUrl)!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10.0))
        
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if String(describing: request.url!).range(of: webUrl) != nil || String(describing: request.url!).range(of: "jsp") != nil {
            return true
        }
        
        switch operation {
        case .CARDPAY:
            if String(describing: request.url!).range(of: Constants.SUCCESS) != nil  {
                self.dismiss(animated: true, completion: nil)
                helper.webSubmited(operation: operation, isSuccess: true)
            } else if String(describing: request.url!).range(of: Constants.FAILURE) != nil {
                self.dismiss(animated: true, completion: nil)
                helper.webSubmited(operation: operation, isSuccess: false)
            }
            return true
        case .CARDADD:
            if String(describing: request.url!).range(of: Constants.SUCCESS) != nil  {
                self.dismiss(animated: true, completion: nil)
                helper.webSubmited(operation: operation, isSuccess: true)
            }
            if String(describing: request.url!).range(of: Constants.FAILURE) != nil  {
                self.dismiss(animated: true, completion: nil)
                helper.webSubmited(operation: operation, isSuccess: false)
            }
            return true
        case .PAYMENT:
            if customer != nil {
                if String(describing: request.url!).range(of: customer!) != nil {
                    return true
                }
            }
            if String(describing: request.url!).range(of: Constants.SUCCESS) != nil  {
                self.dismiss(animated: true, completion: nil)
                helper.webSubmited(operation: operation, isSuccess: true)
            }
            
            if String(describing: request.url!).range(of: Constants.FAILURE) != nil  {
                self.dismiss(animated: true, completion: nil)
                helper.webSubmited(operation: operation, isSuccess: false)
            }
            break
        default:
            break
        }
        return false
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}



