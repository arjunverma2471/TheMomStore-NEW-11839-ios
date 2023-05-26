//
//  CommentedCode.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 30/03/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation

/* AppDelegate+Initialisation File
 
 //Commented for now till further discussion
 
 //            ref?.child("additional_info").child("validity").observe(.value, with: { snapshot in
 //                if let val = snapshot.value as? Bool {
 //                    DispatchQueue.main.async {
 //                        var viewControl =  UIApplication.shared.keyWindow?.rootViewController
 //                        while viewControl?.presentedViewController != nil {
 //                            viewControl = viewControl?.presentedViewController
 //                        }
 //                        if val != true {
 //                            ref?.child("additional_info").child("maintenance_mode").observe(.value, with: { snapValue in
 //                                if let value = snapValue.value as? Bool {
 //                                    if value == true {
 //                                        self?.showMaintainencePopup()
 //                                        return;
 //                                    }
 //                                }
 //                            })
 //                        }
 //                        else {
 //                            self?.showMaintainencePopup()
 //                            return;
 //                        }
 //                        self?.dispatchGroup.leave()
 //                    }
 //                }
 //            })
 
 
 
 
 
 Default Locale Code
 
 
 //                self?.versionManager.getReference(.default_locale, ref)?.observe(.value, with: { snapshot in
 //                    if var val = snapshot.value as? String {
 //                        print(val)
 //                        if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
 //                            // App already launched
 //                            if let value = UserDefaults.standard.value(forKey: "AppleLanguages") as? [String]{
 //                                val = value[0]
 //                            }
 //                        }
 //                        else{
 //                            // This is the first launch ever
 //                            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
 //                            UserDefaults.standard.synchronize()
 //                        }
 //                        UserDefaults.standard.removeObject(forKey: "AppleLanguages")
 //                        UserDefaults.standard.set([val], forKey: "AppleLanguages")
 //                        Client.locale = val
 //                        Client.shared.client = Graph.Client(shopDomain: Client.shopUrl, apiKey: Client.apiKey,locale: Locale(identifier: val))
 //                        Bundle.setLanguage(val)
 //
 //                        DispatchQueue.main.async{
 //                            let rtlLanguages = ["ar","ar-AE","ur"]
 //                            let semanticContentAttribute: UISemanticContentAttribute = rtlLanguages.contains(val) ? .forceRightToLeft : .forceLeftToRight
 //                            customAppSettings.sharedInstance.rtlSupport = rtlLanguages.contains(val) ? true : false
 //                            self?.setSemanticContentAttribute(semanticContentAttribute, for: [UIView.self,UISearchBar.self,UITextView.self,UITextField.self,UIButton.self,UILabel.self,UINavigationBar.self,UICollectionView.self,UIStackView.self
 //                            ])
 //                        }
 //                    }
 //                })
 //
 
 
 self?.versionManager.getReference(.features, ref)?.observe(.value, with: { snapshot in
     if let dataObject = snapshot.value as? [String] {
         customAppSettings.sharedInstance.initializeCustomValue(from: dataObject)
         (UIApplication.shared.delegate as! AppDelegate).loadHomepage()
         
//                        if let rootController = self?.window?.rootViewController as? SWRevealViewController{
//                            if let tabbarControl =  rootController.frontViewController as? TabbarController {
//                                tabbarControl.tabBar.items![0].title = "Home".localized
//                                tabbarControl.tabBar.items![1].title = "Search".localized
//                                tabbarControl.tabBar.items![2].title = "Categories".localized
//                                tabbarControl.tabBar.items![3].title = "Account".localized
//                            }
//                        }
     }
 })
 
 
 
 
 
 
 
 
 
 
 
 */
