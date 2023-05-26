//
//  HomeViewController+Caching.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 13/12/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

extension HomeViewController{
    
    func homeConfigure(){
        setupTable()
        print("Homepage ==@",Client.shared.gettime())
        if let homeJSONData = UserDefaults.standard.value(forKey: "HomeDataJSON") as? Data {//,let val = UserDefaults.standard.value(forKey: "staticJSONEnabled") as? Bool {
            print("====HomeJson Available===")
            shimmer.frame = self.view.bounds
            view.addSubview(shimmer)
            view.bringSubviewToFront(shimmer)
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            do{
                let staticJSON = Client.homeStaticThemeJSON.isEmpty ? homeJSONData : Client.homeStaticThemeJSON
                if let json = try JSONSerialization.jsonObject(with: staticJSON, options: .allowFragments) as? [String:Any] {
                    self.sortOrder  =  sort_order.init(fields: json["sort_order"] as? [String : Any])
                    self.dataSource = json
                    self.shimmer.removeFromSuperview()
                    self.setupNavLayout(snapshop: json)
                    self.view.stopLoader()
                    self.refreshViewControl?.endRefreshing()
                    self.tableView.reloadData()
                    if Client.homeStaticThemeJSON.isEmpty {
                        self.getHomeData(updateHomeData: true)
                    }
                    else {
                        //In case of static theme, no need to check for home updates
                    }
//                    if val {
//                        //In case of static theme, no need to check for home updates
//                    }
//                    else {
//                        self.getHomeData(updateHomeData: true)
//                    }
                     
                    
                }
            }catch{
                print("catchedblock")
            }
            //            }
        }
        else{
            print("====HomeJson Not Available===Fetching HomeJson")
            shimmer.frame = self.view.bounds
            view.addSubview(shimmer)
            view.bringSubviewToFront(shimmer)
            getHomeData()
        }
        tabCountMgmt()
        setupBackgroundHeight()
//        title = "Home".localized
    }
    
    func navConfigure(){
        if let homeJSONData = UserDefaults.standard.value(forKey: "HomeDataJSON") as? Data{
          do{
              let staticJSON = Client.homeStaticThemeJSON.isEmpty ? homeJSONData : Client.homeStaticThemeJSON
            if let json = try JSONSerialization.jsonObject(with: staticJSON, options: .allowFragments) as? [String:Any] {
              self.setupNavLayout(snapshop: json)
            }
          }catch{
            print("catchedblock")
          }
        }
    }
}



