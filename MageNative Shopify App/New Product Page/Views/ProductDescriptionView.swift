//
//  ProductDescriptionView.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 16/05/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class ProductDescriptionView : UIView, WKNavigationDelegate {
    
    var product : ProductViewModel!
    var screenwidth = UIScreen.main.bounds.width
    var parent : ProductVC!
    var dataToShow = ""
    
    lazy var productHeading : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Product Information".localized, for: .normal)
        button.titleLabel?.font = mageFont.mediumFont(size: 14.0)
        button.setTitleColor(UIColor(light: .black,dark: UIColor.provideColor(type: .productVC).textColor), for: .normal)
        button.isUserInteractionEnabled = false
        button.contentHorizontalAlignment = Client.locale == "ar" ? .right : .left
        return button
    }()
    
    
    lazy var webView : WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productVC).backGroundColor)
        view.navigationDelegate = self
        view.scrollView.isScrollEnabled = false
        view.scrollView.bounces = false
        view.scrollView.showsHorizontalScrollIndicator = false
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.numberOfLines = 0
        label.font = mageFont.regularFont(size: 14.0)
        label.textColor = UIColor(light: .black,dark: UIColor.provideColor(type: .productVC).textColor)
        return label;
    }()
    
    lazy var productInfoView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 1
//        view.titleLabel?.font = mageFont.mediumFont(size: 14.0)
//        view.setTitleColor(.black, for: .normal)
//        button.contentHorizontalAlignment = .left
        return view
    }()
    
    lazy var productDetailsHeading: UILabel = {
        let label = UILabel()
        label.text = "Product Details".localized
        label.textColor = UIColor(light: UIColor.init(hexString: "#383838"),dark: UIColor.provideColor(type: .productVC).textColor)
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.numberOfLines = 0
        label.font = mageFont.regularFont(size: 14.0)
        return label;
    }()
    
    lazy var expandCollapseButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "collapsearrow"), for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    lazy var chatGptView : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ChatGPT_logo"), for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(showChatGPTView(_:)), for: .touchUpInside)
        return button
    }()
    
   
    
    
    var showChatGPT = false
    
    var webViewCheck = true;
    
    var descriptionHeight = 0.0
    
    var isExpand = false
   
    var productInfoViewHeightConstraint: NSLayoutConstraint?
    
   
    // MARK:- Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func expandCollapse(_ sender: UIButton){
        if isExpand{
            isExpand = !isExpand
            sender.setImage(UIImage(named: "collapsearrow"), for: .normal)
            productInfoViewHeightConstraint?.isActive = false
            webView.isHidden = false
            self.layoutIfNeeded()
        }else{
            isExpand = !isExpand
            sender.setImage(UIImage(named: "expandarrow"), for: .normal)
            productInfoViewHeightConstraint =  productInfoView.heightAnchor.constraint(equalToConstant: 50)
            productInfoViewHeightConstraint?.isActive = true
            webView.isHidden = true
            self.layoutIfNeeded()
        }
    }
    
    
    func initView() {
        backgroundColor = UIColor(light: .white,dark: UIColor.provideColor(type: .productVC).backGroundColor)
        addSubview(productHeading)
        addSubview(chatGptView)
        addSubview(productInfoView)
        productInfoView.addSubview(expandCollapseButton)
        productInfoView.addSubview(productDetailsHeading)
        productHeading.anchor(top: safeAreaLayoutGuide.topAnchor, left: leadingAnchor, paddingTop: 12, paddingLeft: 10, height: 40)
        chatGptView.anchor(top: safeAreaLayoutGuide.topAnchor,left: productHeading.trailingAnchor, right: trailingAnchor, paddingTop: 12,paddingLeft: 12, paddingRight: 12, width: 40, height: 40)
        productInfoView.topAnchor.constraint(equalTo: productHeading.bottomAnchor, constant: 4).isActive = true
        productInfoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        productInfoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        productInfoView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        
       
        expandCollapseButton.topAnchor.constraint(equalTo: productInfoView.topAnchor, constant: 8).isActive = true
        expandCollapseButton.trailingAnchor.constraint(equalTo: productInfoView.trailingAnchor, constant: -8).isActive = true
        expandCollapseButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        expandCollapseButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        expandCollapseButton.addTarget(self, action: #selector(expandCollapse(_:)), for: .touchUpInside)
        
        productDetailsHeading.topAnchor.constraint(equalTo: productInfoView.topAnchor, constant: 8).isActive = true
        productDetailsHeading.leadingAnchor.constraint(equalTo: productInfoView.leadingAnchor, constant: 8).isActive = true
        productDetailsHeading.trailingAnchor.constraint(equalTo: expandCollapseButton.leadingAnchor, constant: -8).isActive = true
        productDetailsHeading.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if(webViewCheck){
            productInfoView.addSubview(webView)
            webView.anchor(top: productInfoView.topAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 50, paddingLeft: 15, paddingBottom: 15, paddingRight: 15)
            webView.sizeToFit()
        }
        else{
            productInfoView.addSubview(descriptionLabel)
            descriptionLabel.anchor(top: productDetailsHeading.bottomAnchor, left: leadingAnchor, bottom: bottomAnchor, right: trailingAnchor, paddingTop: 50, paddingLeft: 15, paddingBottom: 15, paddingRight: 15)

        }
    }
    
    func setupView() {
    
        if webViewCheck{
            DispatchQueue.main.async { [self] in
              let str="""
                        <html>
                            <head>
                                <meta name='viewport' content='width=device-width,
                        initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'>
                        
                        <link rel="stylesheet" type="text/css" href="webfile.css">
                        <source media="(prefers-color-scheme: dark)">
                        <source media="(prefers-color-scheme: dark)">
                                <style>
                                
                                    body{font-family:Poppins-Regular;width:\(self.screenwidth-30); !important} p{width:\(self.screenwidth-30); !important} div{width:\(self.screenwidth-30) !important} iframe{width:\(self.screenwidth-30) !important} img{width:\(self.screenwidth-30) !important}
                                </style>
                            </head>
                                <body>\(self.product.summary)</body>
                        </html>
                        """
                let alignment = Client.locale == "ar" ? "right" : "left"
                let fontSetting = "<span style=\"text-align: \(alignment);\"</span>"
                self.webView.loadHTMLString(fontSetting+str, baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "webfile", ofType: "css") ?? "" ))
                self.webView.navigationDelegate = self
            }
        }
        else{
            if(self.product.summary != ""){
                var desc = ""
                DispatchQueue.global(qos: .background).async{
                    desc=self.product.summary.htmlToString
                    DispatchQueue.main.async {
                        self.descriptionLabel.text = desc
                    }
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        webView.evaluateJavaScript("document.body.offsetHeight", completionHandler: { (height, error) in
          webView.frame.size.height = 1
          guard let height = height as? CGFloat else{return;}
            self.descriptionHeight = height + 35.0
            self.parent.descriptionHeight = self.descriptionHeight
            self.parent.mainStack.subviews.forEach { subview in
                if let subview = subview as? ProductDescriptionView {
                    subview.webView.heightAnchor.constraint(equalToConstant: self.descriptionHeight).isActive = true
                }
            }
        })
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame,
            frame.isMainFrame {
            return nil
        }
        // for _blank target or non-mainFrame target
        webView.load(navigationAction.request)
        return nil
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == WKNavigationType.linkActivated {
                print("link")
                guard let url = navigationAction.request.url, let scheme = url.scheme, scheme.contains("http") else {
                            // This is not HTTP link - can be a local file or a mailto
                            decisionHandler(.cancel)
                            return
                        }
                print(url)
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                decisionHandler(WKNavigationActionPolicy.cancel)
                return
            }
            print("no link")
            decisionHandler(WKNavigationActionPolicy.allow)
     }
}
extension ProductDescriptionView {
    @objc func showChatGPTView(_ sender: UIButton) {
        let chatView = ProductChatGPTView()
        chatView.tag = 1230
        self.showChatGPT.toggle()
        if self.showChatGPT {
            sender.setImage(UIImage(named: "chat_close"), for: .normal)
            parent.view.addSubview(chatView)
            chatView.anchor(top: chatGptView.bottomAnchor, left: parent.view.leadingAnchor, right: parent.view.trailingAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
            chatView.bottomAnchor.constraint(lessThanOrEqualTo: parent.view.bottomAnchor, constant: -10).isActive = true
            chatView.cardView()
            chatView.stackView.subviews.forEach{$0.removeFromSuperview()}
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = ""
            label.numberOfLines = 0
            label.textColor = UIColor(light: UIColor(hexString: "#6B6B6B"), dark: UIColor(hexString: "#F5F6F6"))
            label.font = mageFont.lightFont(size: 12.0)
            let array = dataToShow.components(separatedBy: " ")
            label.typeOn(data: array)
            chatView.stackView.addArrangedSubview(label)
            
            
        }
        else {
            sender.setImage(UIImage(named: "ChatGPT_logo"), for: .normal)
            chatView.stackView.subviews.forEach{$0.removeFromSuperview()}
            if let view = parent.view.viewWithTag(1230) {
                view.removeFromSuperview()
            }
        }
    }
    
   
    
    func getHeight() -> CGFloat{
        let label = UILabel()
        label.font = mageFont.lightFont(size: 12.0)
        label.numberOfLines = 0
        label.text = dataToShow
        label.sizeToFit()
        return label.bounds.size.height + 20
    }
}
