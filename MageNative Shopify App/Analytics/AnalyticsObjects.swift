//
//  AnalyticsObjects.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 25/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation

//struct AnalyticsDataModel{
//    var time: String
//    var page: String
//}


final class AnalyticsData{
    
    static let shared = AnalyticsData()
    var breadcrump: [[String:Any]]? = [[String:Any]]()
    
    func sharedData(_ feed:[String : Any]){
        self.breadcrump?.append(feed)
        print("📥📥📥 Current Analytics Data==",breadcrump?.description)
    }
}
