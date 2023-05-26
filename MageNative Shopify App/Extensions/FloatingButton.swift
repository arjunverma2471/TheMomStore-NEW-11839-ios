//
//  FloatingButton.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 10/11/21.
//  Copyright © 2021 MageNative. All rights reserved.
//

import Foundation
import ChatSDK
import ChatProvidersSDK
import MessagingSDK
import UIKit
class FloatingButton {
    
    static let shared = FloatingButton()
    var floatingButton : UIButton!
    var leftFloatingButton : UIButton!
    var zendeskFloatingBtn : UIButton!
    var tidioFloatingBtn : UIButton!
    var smileFloatingBtn : UIButton!
    lazy var floatingStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    var controller : UIViewController!
    
    func renderFloatingButton() {
        
        controller.view.addSubview(floatingStack)
    //    controller.view.bringSubviewToFront(floatingStack)
        for view in floatingStack.arrangedSubviews {
            view.removeFromSuperview()
        }
        floatingStack.trailingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        floatingStack.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        floatingStack.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        if customAppSettings.sharedInstance.whatsappInegration {
            self.setUpWhatsappFloatingButton()
        }
        
        if customAppSettings.sharedInstance.fbIntegration {
            self.setUpFBFloatingButton()
        }
        
        if customAppSettings.sharedInstance.smileIntegration {
            self.setUpSmileButton()
        }
        
        if customAppSettings.sharedInstance.zendeskChat {
            self.setZendeskFloatingButton()
           
        }
        
        if customAppSettings.sharedInstance.tidioChat {
            self.setTidioFloatingButton()
        }
    }
    
    func setUpSmileButton() {
        smileFloatingBtn = UIButton()
        smileFloatingBtn.translatesAutoresizingMaskIntoConstraints = false
        smileFloatingBtn.tintColor = UIColor.iconColor
        smileFloatingBtn.setImage(UIImage(named: "reward"), for: .normal)
        smileFloatingBtn.addTarget(self, action: #selector(redirectToSmileIO(_:)), for: .touchUpInside)
        self.floatingStack.addArrangedSubview(smileFloatingBtn)
        smileFloatingBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setUpFBFloatingButton() {
        leftFloatingButton = UIButton()
        leftFloatingButton.translatesAutoresizingMaskIntoConstraints = false
        leftFloatingButton.setTitleColor(UIColor.white, for: .normal)
        leftFloatingButton.setImage(UIImage(named: "messenger-fb"), for: .normal)
        leftFloatingButton.addTarget(self, action: #selector(redirectToFb(_:)), for: .touchUpInside)
        self.floatingStack.addArrangedSubview(leftFloatingButton)
        leftFloatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func redirectToFb(_ sender : UIButton) {
        let url = URL(string: "\(Client.fbURL)")
        if UIApplication.shared.canOpenURL(url!) {
          UIApplication.shared.open(url!)
        }
        else {}
    }
    
    
    @objc func redirectToSmileIO(_ sender : UIButton)
    {
        let webView : WebViewController = controller.storyboard!.instantiateViewController()
        var urlString = ""
        if !Client.shared.isAppLogin() {
            if let loginNavigation = controller.storyboard?.instantiateViewController(withIdentifier:"NewLoginNavigation") {
                loginNavigation.modalPresentationStyle = .fullScreen
                controller.present(loginNavigation, animated: true, completion: nil)
            }
        }else{
            Client.shared.fetchCustomerDetails(completeion: { [self]
                response,error   in
                if let response = response {
                    var cid = ""
                    if let str = response.customerId?.base64decode(){
                        let str1 = str.components(separatedBy: "/")
                        cid = str1.last!
                        print(cid)
                    }
                    urlString = "https://shopifymobileapp.cedcommerce.com/shopifymobile/smilerewardapi/generateview?mid=\(Client.merchantID)&cid="+cid
                    webView.url = urlString.getURL()
                    self.controller.navigationController?.pushViewController(webView, animated: true)
                }else {
                    self.controller.showErrorAlert(error: error?.localizedDescription)
                }
            })
        }
    }
    
    func setZendeskFloatingButton() {
        zendeskFloatingBtn = UIButton()
        zendeskFloatingBtn.translatesAutoresizingMaskIntoConstraints = false
        zendeskFloatingBtn.backgroundColor = UIColor.AppTheme()
        zendeskFloatingBtn.setTitleColor(UIColor.white, for: .normal)
        zendeskFloatingBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        zendeskFloatingBtn.layer.cornerRadius = 15.0
        zendeskFloatingBtn.setTitle("Help".localized, for: .normal)
        zendeskFloatingBtn.setImage(UIImage(named: "question-mark-in-dark-circle"), for: .normal)
        zendeskFloatingBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 15)
        zendeskFloatingBtn.tintColor = UIColor.white
        zendeskFloatingBtn.addTarget(self, action: #selector(showMessagingChat(_:)), for: .touchUpInside)
        self.floatingStack.addArrangedSubview(zendeskFloatingBtn)
        zendeskFloatingBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        zendeskFloatingBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setTidioFloatingButton() {
        tidioFloatingBtn = UIButton()
        tidioFloatingBtn.translatesAutoresizingMaskIntoConstraints = false
        tidioFloatingBtn.backgroundColor = UIColor.AppTheme()
        tidioFloatingBtn.setTitleColor(UIColor.white, for: .normal)
        tidioFloatingBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        tidioFloatingBtn.layer.cornerRadius = 15.0
        tidioFloatingBtn.setTitle("Chat".localized, for: .normal)
        tidioFloatingBtn.setImage(UIImage(named: "outline_question_answer_black_24pt"), for: .normal)
        tidioFloatingBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 15)
        tidioFloatingBtn.tintColor = UIColor.white
        tidioFloatingBtn.addTarget(self, action: #selector(showTidioChat(_:)), for: .touchUpInside)
        self.floatingStack.addArrangedSubview(tidioFloatingBtn)
        tidioFloatingBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        tidioFloatingBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    
    @objc func showTidioChat(_ sender : UIButton) {
        let vc : WebViewController = controller.storyboard!.instantiateViewController()
        vc.title = "Chat with Us".localized
        vc.tidioCheck = true
        vc.url = "http://shopifymobileapp.cedcommerce.com/shopifymobile/tidiolivechatapi/chatpanel?shop=\(Client.shopUrl)".getURL()
        controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showMessagingChat(_ sender : UIButton) {
        do {
             let chatEngine = try ChatEngine.engine()
            let viewController = try Messaging.instance.buildUI(engines : [chatEngine],configs : [])

             controller.navigationController?.pushViewController(viewController, animated: true)
           } catch {
             // handle error
           }
       
        
    }
    func setUpWhatsappFloatingButton() {
        floatingButton = UIButton()
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.setTitleColor(UIColor.white, for: .normal)
        floatingButton.setImage(UIImage(named: "wapp"), for: .normal)
        floatingButton.addTarget(self, action: #selector(redirectToWhatsapp(_:)), for: .touchUpInside)
        self.floatingStack.addArrangedSubview(floatingButton)
        floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func redirectToWhatsapp(_ sender : UIButton) {
        let txt = Client.whatsappMsg
        guard let whatsappURL = "https://api.whatsapp.com/send?phone=\(Client.whatsappNumber)&text=\(txt)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.getURL() else {return}
        if UIApplication.shared.canOpenURL(whatsappURL) {
            UIApplication.shared.open(whatsappURL)
        } else {
            
        }

    }
}
