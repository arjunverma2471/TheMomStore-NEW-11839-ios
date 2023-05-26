//
//  MaintainenceVC.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 29/03/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit

class MaintainenceVC: UIViewController {

    @IBOutlet weak var close: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        close.setTitle("", for: .normal)
        close.addTarget(self, action: #selector(closeMaintainenceView(_:)), for: .touchUpInside)
        
        if Client.merchantPreview{
            close.isHidden = false
        }else{
            close.isHidden = true
        }
    }
    
    @objc func closeMaintainenceView(_ sender: UIButton){
        self.dismiss(animated: true) {
//            self.initialseSecondryDatabase()
            Client.shared.setApiId(id: "c572b018c17d62853985e19b2b11a9a4")
            Client.shared.setMerchantId(merchantId: "18")
            Client.shared.setShopUrl(url: "magenative.myshopify.com")
            Bundle.setLanguage("en")
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
            UserDefaults.standard.removeObject(forKey: "HasLaunchedOnce")
            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
            Client.locale = "en"
            customAppSettings.sharedInstance.rtlSupport = false;
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UISearchBar.appearance().semanticContentAttribute = .forceLeftToRight
            UITextView.appearance().semanticContentAttribute = .forceLeftToRight
            UITextField.appearance().semanticContentAttribute = .forceLeftToRight
            UIButton.appearance().semanticContentAttribute = .forceLeftToRight
            UILabel.appearance().semanticContentAttribute = .forceLeftToRight
            UICollectionView.appearance().semanticContentAttribute = .forceLeftToRight
            UIStackView.appearance().semanticContentAttribute = .forceLeftToRight
            UserDefaults.standard.synchronize()
            self.clearMerchantData()
            (UIApplication.shared.delegate as! AppDelegate).getdata()
            (UIApplication.shared.delegate as! AppDelegate).pushRedirect()
        }
    }
    
    func clearMerchantData(){
        UserDefaults.standard.removeObject(forKey: "HomeDataJSON")
        FirebaseSetup.shared.firebaseInitialiseCheck = false;
        if(UserDefaults.standard.valueExists(forKey: "mageInfo")){
            UserDefaults.standard.removeObject(forKey: "mageInfo")
        }
        UserDefaults.standard.set(false, forKey: "mageShopLogin")
        if(UserDefaults.standard.valueExists(forKey: "defaultCurrency")){
            UserDefaults.standard.removeObject(forKey: "defaultCurrency")
        }
        WishlistManager.shared.clearWishlist()
        CartManager.shared.deleteAll()
        customAppSettings.sharedInstance.disableCustomSettings()
        Client.shared.client = Graph.Client(shopDomain: Client.shopUrl, apiKey: Client.apiKey, locale: Locale(identifier: Client.locale))
    }
}
