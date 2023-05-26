//
//  WKWebView+Extension.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 26/07/20.
//  Copyright © 2020 MageNative. All rights reserved.
//
import WebKit
class WebViewCookies{
    func clearCookies(){
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("All cookies deleted")
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            print("Cookie ::: \(record) deleted")
          }
        }
    }
}
