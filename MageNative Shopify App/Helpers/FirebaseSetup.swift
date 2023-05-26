//
//  FirebaseSetup.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 28/05/20.
//  Copyright © 2020 MageNative. All rights reserved.
//

import Foundation
enum Environment{
    case liveEnvironment
    case livePreview
    case devEnvironment
    case devPreview
}

final class FirebaseSetup{
    private init(){}
    static let shared = FirebaseSetup()
    var firebaseInitialiseCheck = false;
    func configureFirebase(){
        let shopurl = Client.shopUrl.replacingOccurrences(of: ".myshopify.com", with: "")
        if(!firebaseInitialiseCheck){
            if(FirebaseApp.app(name: shopurl) == nil){
                firebaseInitialiseCheck = true;
                FirebaseApp.configure(name: shopurl, options: FirebaseSetup.shared.initDetails())
            }
        }
    }
    func initDetails()->FirebaseOptions{
        switch Client.environment {
        case .liveEnvironment:
            let secondaryOptions = FirebaseOptions(googleAppID: "1:322600045606:ios:29f20b52def299c1ab6ae7", gcmSenderID: "322600045606")
            secondaryOptions.bundleID = "com.magenative.ShopifyApp"
            secondaryOptions.apiKey = "AIzaSyANH3vJX4vjVW6wZUZVzYl1Fq3MLFZUjwM"
            secondaryOptions.clientID = "322600045606-oe42b1aq0ti80fs72nqrjkdgk68oqfn1.apps.googleusercontent.com"
            secondaryOptions.databaseURL = "https://live-shopify-project.firebaseio.com"
            secondaryOptions.storageBucket = "live-shopify-project.appspot.com"
            secondaryOptions.projectID = "live-shopify-project"
            return secondaryOptions
            
        case .livePreview:
            let secondaryOptions = FirebaseOptions(googleAppID: "1:445702503308:ios:cabc74c8300dde1a68b4a9", gcmSenderID: "445702503308")
            secondaryOptions.bundleID = "com.magenative.ShopifyApp"
            secondaryOptions.apiKey = "AIzaSyBWSD3iqnRP6sOKTnkDJOvEc4i3bhnVakM"
            secondaryOptions.clientID = "445702503308-ea0d943ivpfjmsk7gn6o3qfm99p0gp0o.apps.googleusercontent.com"
            secondaryOptions.databaseURL = "https://shopify-dev-project-2f51e.firebaseio.com"
            secondaryOptions.storageBucket = "shopify-dev-project-2f51e.appspot.com"
            secondaryOptions.projectID = "shopify-dev-project-2f51e"
            return secondaryOptions
            
        case .devEnvironment:
            // Original
            
//            let secondaryOptions = FirebaseOptions(googleAppID: "1:275196381712:ios:9ebfff580248a09c7b5895", gcmSenderID: "275196381712")
//            secondaryOptions.bundleID = "com.magenative.ShopifyApp"
//            secondaryOptions.apiKey = "AIzaSyDOV7aCrExAn4vIGZ9ttYuQcUwn0X6PlOM"
//            secondaryOptions.clientID = "275196381712-d3qv46qf8975bvf0msrst8d05rva586s.apps.googleusercontent.com"
//            secondaryOptions.databaseURL = "https://development-live-shopify.firebaseio.com"
//            secondaryOptions.storageBucket = "development-live-shopify.appspot.com"
//            secondaryOptions.projectID = "development-live-shopify"
//            return secondaryOptions
            
            
//MARK: - Changed the value on 28 Feb,2023 by Yash
            
            
            let secondaryOptions = FirebaseOptions(googleAppID: "1:132710677937:ios:a284473bd9b353b8285190", gcmSenderID: "132710677937")
            secondaryOptions.bundleID = "com.magenative.ShopifyApp"
            secondaryOptions.apiKey = "AIzaSyDpn2RGoAybqWikv25ZvR5fi69oTgtKEr8"
            secondaryOptions.clientID = "132710677937-uon6hhrd58k4j6ciuelb4tkkj13h4hi2.apps.googleusercontent.com"
            secondaryOptions.databaseURL = "https://magenative-dev-server-preview-default-rtdb.firebaseio.com"
            secondaryOptions.storageBucket = "magenative-dev-server-preview.appspot.com"
            secondaryOptions.projectID = "magenative-dev-server-preview"
            return secondaryOptions
            
//            let secondaryOptions = FirebaseOptions(googleAppID: "1:132710677937:ios:a284473bd9b353b8285190", gcmSenderID: "132710677937")
//            secondaryOptions.bundleID = "com.magenative.ShopifyApp"
//            secondaryOptions.apiKey = "AIzaSyDpn2RGoAybqWikv25ZvR5fi69oTgtKEr8"
//            secondaryOptions.clientID = "275196381712-d3qv46qf8975bvf0msrst8d05rva586s.apps.googleusercontent.com"
//            secondaryOptions.databaseURL = "https://magenative-dev-server-preview-default-rtdb.firebaseio.com"
//            secondaryOptions.storageBucket = "magenative-dev-server-preview.appspot.com"
//            secondaryOptions.projectID = "magenative-dev-server-preview"
//            return secondaryOptions
//
        default:
            /*let secondaryOptions = FirebaseOptions(googleAppID: "1:1007468803704:ios:70487159a66e0020", gcmSenderID: "1007468803704")
            secondaryOptions.bundleID = "com.magenative.ShopifyApp"
            secondaryOptions.apiKey = "AIzaSyAEAE2Yc8U68QTCqdEzqlKQY7wFKsf3MOI"
            secondaryOptions.clientID = "1007468803704-vnsml5u7frvjcqmehfhdunon7tqf2m01.apps.googleusercontent.com"
            secondaryOptions.databaseURL = "https://computer-village-152715.firebaseio.com"
            secondaryOptions.storageBucket = "computer-village-152715.appspot.com"
            secondaryOptions.projectID = "computer-village-152715"
            return secondaryOptions*/
            let secondaryOptions = FirebaseOptions(googleAppID: "1:132710677937:ios:a284473bd9b353b8285190", gcmSenderID: "132710677937")
            secondaryOptions.bundleID = "com.magenative.ShopifyApp"
            secondaryOptions.apiKey = "AIzaSyDpn2RGoAybqWikv25ZvR5fi69oTgtKEr8"
            secondaryOptions.clientID = "132710677937-uon6hhrd58k4j6ciuelb4tkkj13h4hi2.apps.googleusercontent.com"
            secondaryOptions.databaseURL = "https://magenative-dev-server-preview-default-rtdb.firebaseio.com"
            secondaryOptions.storageBucket = "magenative-dev-server-preview.appspot.com"
            secondaryOptions.projectID = "magenative-dev-server-preview"
            return secondaryOptions
            
        }
    }
}
