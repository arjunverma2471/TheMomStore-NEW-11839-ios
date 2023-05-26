//
//  customAppSettings.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 10/03/21.
//  Copyright © 2021 MageNative. All rights reserved.
//
import Foundation
import MobileBuySDK
import CoreImage
import RxCocoa
import RxSwift

class customAppSettings
{
    static let sharedInstance = customAppSettings()
    var augmentedReality : Bool = false
    var inAppWishlist : Bool = false
    var wishlistCheck = BehaviorSubject(value: false)
    var productShare : Bool = false
    var multiCurrency : Bool = false
    var multiLanguage : Bool = false
    var abandonedCartCompaigns : Bool = false
    var aiProductRecomendaton : Bool = false
    var qrCodeSearchScanner : Bool = false
    var inAppRatingReview : Bool = false
    var inAppRatingReviewJudgeMe:Bool=false
    var kiwiSizeChart:Bool=false
    var reorder:Bool=false
    var inAppAddToCart:Bool=false
    var outOfStocklabel:Bool=false
    var shopifyRecommendedProducts:Bool=false
    var aliReview:Bool=false
    var yotpoLoyalty:Bool=false
    var zendeskChat:Bool=false
    var tidioChat:Bool=false
    var zapietIntegration:Bool=false
    var yotpoReviews:Bool=false
    var whatsappInegration:Bool=false
    var firstOrderDiscount = false
    var fbIntegration:Bool=false
    var filterIntegration:Bool=false
    var smileIntegration:Bool=false
    var socialLoginEnabled:Bool=false
    var nativeOrderPage:Bool=false
    var showTabbar:Bool=false
    var tab = BehaviorSubject(value: false)
    var rtlSupport : Bool = false
    var subscriptionProduct : Bool = false
    var rewardify: Bool = false;
    var nativeCheckout : Bool = false;
    var flitsIntegration: Bool = false;
    var algoliaIntegration: Bool = false;
    var backInStockIntegration : Bool = false
    var wholesalePricingDiscount : Bool = false;
    var returnPrime : Bool = false
    //var deepLinking : Bool = false
    var isDropDownVariant : Bool = false
    var instaFeedPosition : Int = 7
    var isInstaFeed : Bool = false
    var shipwayIntegration : Bool = false
    var hideTabbarOnProduct: Bool = false
    var isFastSimonSearchEnabled: Bool = false
    var boostCommerceEnabled: Bool = false
    var boostCommerceFilterEnabled: Bool = false
    var lipShadeTryon: Bool = false;
    var instaFeedCount = 0;
    var instaViewType: InstaType = .grid
    var instaText = ""
    var enableHomeCaching = true
    var isFeraReviewsEnabled = false
    var growaveRewardsIntegration = false
    var isGrowaveWishlist = false
    var isGrowaveReviewsIntegration = false
    var isSimplyOTPEnabled = false
    var isKangarooRewardsEnabled = false
    var reviewsIO = false
    var chatgpt = true
    var shopifyInbox = false
    func initializeCustomValue(from dataObject:[String]) {
        if dataObject.count > 0
        {
            if(dataObject.contains("augmented-reality")){
                self.augmentedReality = true
            }
            
            if(dataObject.contains("in-app-whislist")){
                self.inAppWishlist = true
                wishlistCheck.onNext(true)
            }
            
            if(dataObject.contains("product-share")){
                self.productShare = true
            }
            
            if(dataObject.contains("multi-currency")){
                self.multiCurrency = true
            }
            
            if(dataObject.contains("multi-language")){
                self.multiLanguage = true
            }
            
            if(dataObject.contains("abandoned-cart-campaigns")){
                self.abandonedCartCompaigns = true
                self.checkForAbandonCart()
            }
            
            if(dataObject.contains("qr-code-search-scanner")){
                self.qrCodeSearchScanner = true
            }
            
            if(dataObject.contains("reorder")){
                self.reorder = true
            }
            
            if(dataObject.contains("add_to_cart")){
                self.inAppAddToCart = true
            }
            
            if(dataObject.contains("out_of_stock")){
                self.outOfStocklabel = true
            }
            
            if(dataObject.contains("recommended_products")){
                self.shopifyRecommendedProducts = true
            }
            
            if(dataObject.contains("social_login")){
                self.socialLoginEnabled = true
            }
            
            if dataObject.contains("native_order_view") {
                self.nativeOrderPage = true
            }
            if dataObject.contains("native_checkout") {
                self.nativeCheckout = true
            }
            
            if dataObject.contains("show_bottom_navigation") {
                self.showTabbar = true
                self.tab.onNext(true)
            }
            else{
                self.showTabbar = false
                self.tab.onNext(false)
            }
            if dataObject.contains("rtl-Support") {
                self.rtlSupport = true
                
            }
            
            if dataObject.contains("variant_dropdown") {
                self.isDropDownVariant = true
            }
            if dataObject.contains("lipshade_tryon"){
                self.lipShadeTryon = true;
            }
        }
    }
    
    func checkForAbandonCart() {
        if(DBManager.shared.cartProducts?.count ?? 0 > 0){
            CartManager.shared.getAccessLocalNotification()
        }
        else{
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["magenative_cart_notification_center"])
        }
    }
    
    func checkForIntegrations(from dataObject : DataSnapshot) {
        if let valuesArray = dataObject.value as? [[String:Any]]{
            print("---values---")
            print(valuesArray)
            for item in valuesArray{
                if let id = item["id"] as? String{
                    switch id{
                    case "I01":
                        self.inAppRatingReview = true
                    case "I02":
                        self.yotpoReviews = false   /*CHANGE THIS*/
                        if let inputs = item["inputs"] as? [String:Any], let apiKey = inputs["apiKey"] as? String, let secret = inputs["client_secret"] as? String{
                            Client.yotpoClientId = apiKey
                            Client.yotpoClientSecret = secret
                        }
                    case "I03" :
                        self.inAppRatingReviewJudgeMe = true
                        if let inputs = item["inputs"] as? [String:Any], let apiKey = inputs["apiKey"] as? String{
                            Client.judgemeApikey = apiKey
                        }
                    case "I04" :
                        self.kiwiSizeChart = true
                    case "I05" :
                        self.zendeskChat = true
                        if let inputs = item["inputs"] as? [String:Any], let apiKey = inputs["apiKey"] as? String{
                            Client.zendeskAccountKey = apiKey
                        }
                    case "I06" :
                        self.tidioChat = true
                    case "I07" :
                        self.zapietIntegration = true
                    case "I12" :
                        self.yotpoLoyalty = true
                        if let inputs = item["inputs"] as? [String:Any], let apiKey = inputs["apiKey"] as? String, let guid = inputs["guid"] as? String{
                            Client.yotpoRewardApiKey = apiKey
                            Client.yotpoRewardGUID = guid
                        }
                    case "I13" :
                        self.aliReview = true
                    case "I14" :
                        self.aiProductRecomendaton = true
                    case "I15" :
                        self.algoliaIntegration = true
                        if let inputs = item["inputs"] as? [String:Any], let apiKey = inputs["apiKey"] as? String, let appId = inputs["appId"] as? String, let indexName = inputs["indexName"] as? String{
                            Client.algoliaApiKey = apiKey
                            Client.algoliaAppId = appId
                            Client.algoliaIndexName = indexName
                        }
                    case "I16" :
                        self.returnPrime = true
                        if let inputs = item["inputs"] as? [String:Any], let apiKey = inputs["channelId"] as? String{
                            Client.returnChannelId = apiKey
                        }
                    case "I17" :
                        self.flitsIntegration = true
                        if let inputs = item["inputs"] as? [String:Any], let apiKey = inputs["token"] as? String, let appId = inputs["userId"] as? String{
                            Client.flitsToken = apiKey
                            Client.flitsUserId = appId
                        }
                    case "I18":
                        print("appstle")
                        
                    case "I19" :
                        self.shipwayIntegration = true
                    case "I20":
                        self.boostCommerceEnabled = true
                        self.boostCommerceFilterEnabled = true
                       /* self.wholesalePricingDiscount = true // Removed as it is not listed on panel
                        if let inputs = item["inputs"] as? [String:Any], let apiKey = inputs["authorization"] as? String, let appId = inputs["apiKey"] as? String{
                            Client.wholesaleAuthorization = apiKey
                            Client.wholesaleApiKey = appId
                        } */
                    case "I21":
                        self.reviewsIO = true
                    case "I22":
                        self.shipwayIntegration = true
                    case "I23" :
                        print("stamped")
                    case "I24" :
                        self.isSimplyOTPEnabled = true
                    case "I25" :
                        self.shopifyInbox = true
                    case "I26" :
                        self.growaveRewardsIntegration = true
                        self.isGrowaveWishlist = true
                        self.isGrowaveReviewsIntegration = true
                        if let inputs = item["inputs"] as? [String:Any], let apiKey = inputs["client_id"] as? String, let appId = inputs["client_secret"] as? String{
                            Client.growaveClientId = apiKey
                            Client.growaveClientSecret = appId
                        }
                    case "I27" :
                        self.rewardify = true
                        if let inputs = item["inputs"] as? [String:Any], let apiKey = inputs["client_id"] as? String, let appId = inputs["client_secret"] as? String{
                            Client.rewardifyClientId = apiKey
                            Client.rewardifyClientSecret = appId
                        }
                    case "":
                        if let title = item["title"] as? String{
                            if(title == "features"){
                                if let inputs = item["inputs"] as? [String:Any]{
                                    if(inputs.keys.contains("whatsapp")){
                                        if let whatsapp = inputs["whatsapp"] as? [String:Any], let whatsappInput = whatsapp["inputs"] as? [String:Any], let mobile = whatsappInput["mobile_no"] as? String{
                                            if(mobile != ""){
                                                self.whatsappInegration = true
                                                Client.whatsappNumber = mobile
                                                Client.whatsappMsg = ""
                                            }
                                        }
                                    }
                                    
                                    if(inputs.keys.contains("facebook-chat")){
                                        if let facebookChat = inputs["facebook-chat"] as? [String:Any], let facebookInput = facebookChat["inputs"] as? [String:Any], let userId = facebookInput["user_id"] as? String{
                                            if(userId != ""){
                                                self.fbIntegration = true
                                                Client.fbURL = userId
                                            }
                                        }
                                    }
                                    if (inputs.keys.contains("first_order_discount")) {
                                        if let firstOrderDiscount = inputs["first_order_discount"] as? [String: Any], let discountInput = firstOrderDiscount["inputs"] as? [String: Any], let couponCode = discountInput["coupon_code"] as? String {
                                            if (couponCode != "") {
                                                self.firstOrderDiscount = true
                                                Client.firstOrderCouponCode = couponCode
                                            }
                                        }
                                    }
                                    
                                    
                                    if(inputs.keys.contains("instagram")){
                                        if let instagram = inputs["instagram"] as? [String:Any], let instaInput = instagram["inputs"] as? [String:Any], let range = instaInput["instagram_range"] as? String, let view = instaInput["instagram_view"] as? String, let title = instaInput["widget_title"] as? String{
                                            if(range != ""){
                                                customAppSettings.sharedInstance.instaFeedCount = Int(range)!
                                            }
                                            if(view != ""){
                                                if(view=="grid"){
                                                    customAppSettings.sharedInstance.instaViewType = .grid
                                                }
                                                else{
                                                    customAppSettings.sharedInstance.instaViewType = .scroll
                                                }
                                            }
                                            if(title != ""){
                                                customAppSettings.sharedInstance.instaText = title
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    default:
                        print("integrations")
                    }
                }
            }
        }
    }
    
    func disableCustomSettings(){
        self.wishlistCheck.onNext(false)
        augmentedReality = false
        inAppWishlist = false
        productShare = false
        multiCurrency = false
        multiLanguage = false
        abandonedCartCompaigns = false
        aiProductRecomendaton = false
        qrCodeSearchScanner = false
        inAppRatingReview = false
        inAppRatingReviewJudgeMe = false
        kiwiSizeChart = false
        reorder = false
        inAppAddToCart=false
        outOfStocklabel=false
        shopifyRecommendedProducts=false
        aliReview=false
        yotpoLoyalty=false
        zendeskChat=false
        tidioChat = false
        zapietIntegration = false
        yotpoReviews = false
        whatsappInegration = false
        fbIntegration = false
        filterIntegration = false
        Client.yotpoRewardApiKey = ""
        Client.yotpoClientId = ""
        Client.yotpoClientSecret = ""
        Client.judgemeApikey = ""
        Client.yotpoRewardGUID = ""
        Client.whatsappNumber = ""
        Client.fbURL = ""
        socialLoginEnabled = false;
        smileIntegration = false;
        flitsIntegration=false;
        algoliaIntegration=false;
        returnPrime=false;
        Client.flitsUserId="";
        Client.flitsToken="";
        Client.returnChannelId="";
        Client.algoliaIndexName="";
        Client.algoliaApiKey="";
        Client.returnChannelId=""
        isDropDownVariant=false
        rewardify=false
        backInStockIntegration=false
        isInstaFeed=false
        shipwayIntegration=false
        wholesalePricingDiscount=false
        Client.wholesaleAuthorization = ""
        Client.wholesaleApiKey = ""
        Client.rewardifyClientId = ""
        Client.rewardifyClientSecret = ""
        lipShadeTryon = false
        tab.onNext(false)
        self.boostCommerceEnabled = false
        self.boostCommerceFilterEnabled = false
        self.reviewsIO = false
        self.isSimplyOTPEnabled = false
        self.growaveRewardsIntegration = false
        self.isGrowaveWishlist = false
        self.isGrowaveReviewsIntegration = false
        Client.rewardifyClientId = ""
        Client.rewardifyClientSecret = ""
        self.shopifyInbox = false
        
    }
    
    func setAllCustomSettingsTrue() {
        self.augmentedReality = true
        self.inAppWishlist = true
        self.wishlistCheck.onNext(true)
        // self.rtlSupport = true
        self.productShare = true
        self.multiCurrency = true
        self.multiLanguage = true
        self.abandonedCartCompaigns = true
        //self.deepLinking = true
        self.qrCodeSearchScanner = true
        self.aiProductRecomendaton = true
        self.inAppRatingReview = true
        self.inAppRatingReviewJudgeMe = true
        self.kiwiSizeChart = true
        self.inAppAddToCart = true
        self.outOfStocklabel = true
        self.shopifyRecommendedProducts = true
        self.aliReview = true
        self.smileIntegration = true;
        self.socialLoginEnabled = true;
        
        isDropDownVariant=true
    }
}

enum InstaType{
    case grid
    case scroll
}
