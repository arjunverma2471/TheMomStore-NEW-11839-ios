//
//  LanguageUpdations.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 09/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

class LanguageUpdation{
    static func selectStore(store:String,code:String){
        let code = code.lowercased()
        print("Selection==",store,code)
        let rtlLanguages = ["ar","ar-AE","ur"]
        customAppSettings.sharedInstance.rtlSupport = rtlLanguages.contains(code) ? true : false
        switch code.lowercased() {
        case "ar","ar-AE":
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
            UserDefaults.standard.set(["ar"], forKey: "AppleLanguages")
            Client.locale = "ar"
            Client.shared.client = Graph.Client(shopDomain: Client.shopUrl, apiKey: Client.apiKey,locale: Locale(identifier: "ar"))
            Bundle.setLanguage("ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UISearchBar.appearance().semanticContentAttribute = .forceRightToLeft
            UITextView.appearance().semanticContentAttribute = .forceRightToLeft
            UITextField.appearance().semanticContentAttribute = .forceRightToLeft
            UIButton.appearance().semanticContentAttribute = .forceRightToLeft
            UILabel.appearance().semanticContentAttribute = .forceRightToLeft
            UICollectionView.appearance().semanticContentAttribute = .forceRightToLeft
            UIStackView.appearance().semanticContentAttribute = .forceRightToLeft
            UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
        default:
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
            UserDefaults.standard.set([code], forKey: "AppleLanguages")
            Client.locale = code
            Client.shared.client = Graph.Client(shopDomain: Client.shopUrl, apiKey: Client.apiKey,locale: Locale(identifier: code))
            Bundle.setLanguage(code)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UISearchBar.appearance().semanticContentAttribute = .forceLeftToRight
            UITextView.appearance().semanticContentAttribute = .forceLeftToRight
            UITextField.appearance().semanticContentAttribute = .forceLeftToRight
            UIButton.appearance().semanticContentAttribute = .forceLeftToRight
            UILabel.appearance().semanticContentAttribute = .forceLeftToRight
            UICollectionView.appearance().semanticContentAttribute = .forceLeftToRight
            UIStackView.appearance().semanticContentAttribute = .forceLeftToRight
            UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
}
