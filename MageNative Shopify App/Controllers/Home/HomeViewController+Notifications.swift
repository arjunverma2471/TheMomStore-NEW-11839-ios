//
//  HomeViewController+Notifications.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 06/04/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import Foundation
extension HomeViewController
{
    func redirectPushNotifications()
    
    {
        let seconds = 1.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            if UserDefaults.standard.value(forKey: "MageNotificationData") != nil
            {
                let data=UserDefaults.standard.value(forKey: "MageNotificationData") as! [String:Any]
                UserDefaults.standard.removeObject(forKey: "MageNotificationData")
                if let linkType = data["link_type"] as? String {
                    if let notificationData = UserDefaults.standard.value(forKey: "NotificationData") as? [String:String] {
                        if (linkType == "product"){
                            let productview=ProductVC()//:ProductViewController = self.storyboard!.instantiateViewController()
                            self.productId = notificationData["product"]
                            productview.productId = self.productId!
                            productview.isProductLoading = true;
                            self.navigationController?.pushViewController(productview
                                                                          , animated: true)
                        }
                        else  if (linkType == "collection")
                        {
                            let link_id = data["link_id"] as! String
                            let coll = collection(id: link_id, title: "collection")
                            let viewControl = ProductListVC()//:ProductListViewController = self.storyboard!.instantiateViewController()
                            viewControl.isfromHome = true
                            viewControl.collect = coll
                            self.navigationController?.pushViewController(viewControl, animated: true)
                        }
                        
                        else  if (linkType == "web_address"){
                            let webView:WebViewController = self.storyboard!.instantiateViewController()
                            let link_id = data["link_id"] as! String
                            webView.url = link_id.getURL()
                            self.navigationController?.pushViewController(webView
                                                                          , animated: true)
                        }
                    }
                    if (linkType == "cart"){
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let data = DBManager.shared.cartProducts?.filter{$0.sellingPlanId != ""}
                        if data?.count ?? 0 > 0 {
                            let vc : NewCartViewController = storyboard.instantiateViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else {
                            let vc : CartViewController = storyboard.instantiateViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                
            }
        }
    }
}
