//
//  FirebaseAnalyticsRecord.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 01/03/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation

struct ContentData: Encodable{
  let name: String
  let id: String
  let quantity: Int
}

final class AnalyticsFirebaseData{
    
    static let shared = AnalyticsFirebaseData()
   
    func firebaseProductEvent(product: ProductViewModel){
        
        let currency        = Client.shared.getCurrencyCode() ?? ""
        let price           = product.variants.items.first?.price.description ?? ""
        let desc            = product.title
        let productDetails: [String: Any] = [AnalyticsParameterCurrency: currency,AnalyticsParameterPrice: price,AnalyticsParameterItemName:desc]
        Analytics.logEvent(AnalyticsEventViewItem, parameters: productDetails)
    }
    
    func firebaseSearchEvent(term:String){
        let searchDetails: [String: Any] = [AnalyticsParameterSearchTerm: term]
        Analytics.logEvent(AnalyticsEventSearch, parameters: searchDetails)
    }
    
    func firebaseCategoryEvent(category:String){
        let searchDetails: [String: Any] = [AnalyticsParameterItemCategory: category]
        Analytics.logEvent("Category Clicked", parameters: searchDetails)
    }
    
    func firebaseSourceOfOpen(source:String){
        let sourceDetails: [String: Any] = [AnalyticsParameterSource: source]
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: sourceDetails)
    }
    
    func firebaseUserSignUp(email:String){
        let sourceDetails: [String: Any] = ["UserEmail": email]
        Analytics.logEvent(AnalyticsEventSignUp, parameters: sourceDetails)
    }
    
    func firebaseUserAppLogin(email:String){
        let sourceDetails: [String: Any] = ["UserEmail": email]
        Analytics.logEvent(AnalyticsEventLogin, parameters: sourceDetails)
    }
     
}

