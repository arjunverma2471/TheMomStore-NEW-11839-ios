/**
 * CedCommerce
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the End User License Agreement (EULA)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://cedcommerce.com/license-agreement.txt
 *
 * @category  Ced
 * @package   MageNative
 * @author    CedCommerce Core Team <connect@cedcommerce.com >
 * @copyright Copyright CEDCOMMERCE (http://cedcommerce.com/)
 * @license      http://cedcommerce.com/license-agreement.txt
 */

import Foundation
//import MobileBuySDK

final class Client {
  // ----------------------------------
  //  MARK: - Shop url of merchant -
  //
    
  static var shopUrl: String {
    if let url = UserDefaults.standard.value(forKey: "shopUrl") as? String{
      return url
    }
    else{
//      return "50shadesofcloths.myshopify.com"
     return "tms-the-mom-store.myshopify.com"//""//"lilystore28.myshopify.com"//
//        return "yourownfactory.myshopify.com"
 //       return "beargrillstore.myshopify.com"
    }
  }
    
    static var coupon: String {
        if let url = UserDefaults.standard.value(forKey: "coupon") as? String{
          return url
        }
        else{
          return ""
        }
    }

  // ----------------------------------
  //  MARK: - Merchant id of the store -
  //
  static var merchantID: String{
    if let url = UserDefaults.standard.value(forKey: "merchantId") as? String{
      return url
    }
    else{
//
//      return "8045"
        return "11839"
//        return "7268"
    }
  }

  // ----------------------------------
  //  MARK: - Api key of store -
  //
  static var apiKey: String{
    if let url = UserDefaults.standard.value(forKey: "apiKey") as? String{
      return url
    }
    else{
      return "80108c59639081b7735282aaddd5175e"
//        return "ef4bcbd0c38ababb0754080cdfd25629"
    }
  }
    static var zendeskAccountKey = ""
    
    static let appLiveUrl = "https://apps.apple.com/us/app/magenative-shopify-app/id1266263558"
    
    static var whatsappNumber = "+916393417500"
    
    static var whatsappMsg = "Hi! Welcome to Magenative Store"
    
    static var fbURL = "https://m.me/MageNative"
    
    static var firstOrderCouponCode = String()
    
    static var yotpoClientId = String()
    
    static var yotpoClientSecret = String()
    
    static var yotpoRewardGUID = String()
    
    static var yotpoRewardApiKey = String()
    
    static var judgemeApikey = String()
    
    static var algoliaAppId = String()
    
    static var algoliaApiKey = String()
    
    static var algoliaIndexName = String()
    
    static var flitsToken = "b7e0df7341529fe4a782bc9ca3931f0a"
    
    static var flitsUserId = "24088"
  
    static var fastSimonUUID = "2d93c375-8e47-4577-a50e-278345db7d73"
  
    static var fastSimonStoreId = "22806971"
    
    static var reviewsIOApiKey = "a9825b96e01b498c24686e949819a566"
    
    static var growaveClientId      = "6ee7fdd01122cd565007ccc30905261e"
    static var growaveClientSecret  = "a0e1c018ad2265b421d477aa0e4175b0"

    static var returnChannelId = String()
    
    static var wholesaleAuthorization = String()
    
    static var wholesaleApiKey = String()
    
    static var rewardifyClientId = "530_4louf0q4fh2c0g0cowoo88og80k8skssko8sc88osss80c4kos"//String()
    
    static var rewardifyClientSecret = "6qtecz1cv9k4wccksg0o00wkg408gookks044ocwos848kggo"//String()
    
    static var chatGPTtoken = "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"
    
    static let merchantPreview = false
    
    static var homeStaticThemeJSON = Data()
    
    static var homeStaticThemeColor = String()
  
   private let defaults = UserDefaults.standard
   static let loginUrl = "http://\(Client.shopUrl)/account/login"
   static var navigationThemeData: HomeTopBarViewModel?
   static var availableLanguageFB = [String]()
 
  // ----------------------------------
  //  MARK: -Firebase message topic -
  //
    
  static let messageTopic = "magenativeIOS"
  static let shared = Client()
  static var locale = "en"
    
static var theme: String{
        if let theme = UserDefaults.standard.value(forKey: "theme") as? String{
          return theme
        }
        else{
    //      return "9846"
            return "unspecified"
        }
      }
  // ----------------------------------
  //  MARK: - Environment for firebase -
  //
    static var environment: Environment = .livePreview
    
    // ----------------------------------
    //  MARK: - Environment for Insta Feed -
    //
    static var INSTA_ACCESS_TOKEN = "IGQVJYUmRaQmZAxTWk1UndRem9DSUhCM1BXN0lwc1BFR1c4SzdqUnJMVXJhQlltR1FnX2pESm52UHlqUUZAwM3lXclNrX2tHcjRRZAlJLT2k0c1J4TEV3bXBURDNxVkpadlh2YkpOblBIZAnpmd0ItMGxvTgZDZD"
    static let BASE_INSTAGRAM_URL = "https://www.instagram.com/"
    static let BASE_INSTAGRAM_GRAPH_URL = "https://graph.instagram.com/me/media?"
    
  var client: Graph.Client = Graph.Client(shopDomain: Client.shopUrl, apiKey: Client.apiKey, locale: Locale(identifier: Client.locale))
  
  // --------------------------------
  //  MARK: - Init
  //
  private init() {
    self.client.cachePolicy = .cacheFirst(expireIn: 3600)
  }

    func gettime()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm::ss"
        let date = dateFormatter.string(from: Date())
        return date
    }
  
  // --------------------------------
  //  MARK: - Save shop url
  //
  
  func setShopUrl(url: String){
    defaults.set(url, forKey: "shopUrl");
  }
  
  // ----------------------------------
  //  MARK: - Save Api key -
  //
  
  func setApiId(id: String){
    defaults.set(id, forKey: "apiKey")
  }
  
  // ----------------------------------
  //  MARK: - Save merchant id -
  //
  
  func setMerchantId(merchantId: String){
    defaults.set(merchantId, forKey: "merchantId")
  }
  
  // ----------------------------------
  //  MARK: - Get Language -
  //
  @discardableResult
  func getLanguageCode() -> MobileBuySDK.Storefront.LanguageCode{
    var language = MobileBuySDK.Storefront.LanguageCode.en
      if let languageCode = UserDefaults.standard.value(forKey: "AppleLanguages") as? [String]{
        if let code = languageCode.first {
          language = MobileBuySDK.Storefront.LanguageCode(rawValue: code.uppercased()) ?? language
          }
        }
      return language
  }
    
    // ----------------------------------
    //  MARK: - Get Currency -
    //
    @discardableResult
    func getCurrencyCodeVal() -> MobileBuySDK.Storefront.CountryCode{
        var currency = MobileBuySDK.Storefront.CountryCode.in
        if let currencyCode = UserDefaults.standard.value(forKey: "mageCountryCode") as? String{
            currency = MobileBuySDK.Storefront.CountryCode(rawValue: currencyCode) ?? currency
        }
        return currency
    }
  
    // ----------------------------------
    //  MARK: - InterNational Currency -
    //
    @discardableResult
    func currencyCode(completion: @escaping (CurrencyViewModel?) -> Void) -> Task {
      
      let query = ClientQuery.queryForCurrency()
      let task  = self.client.queryGraphWith(query) { (query, error) in
        error.errorPrint()
        if let query = query {
          print("--fetch-- \(query)")
            completion(query.localization.viewModel)
        } else {
          print("Failed to fetch shop name: \(String(describing: error))")
          completion(nil)
        }
      }
      
      task.resume()
      return task
    }
  
  // ----------------------------------
  //  MARK: - Set text color according to theme -
  //
  
  func setTextColor(val: String){
    var colorCode = val
    if colorCode.lowercased().contains("fffff") || colorCode.lowercased().contains("fcfcf"){
      colorCode = "000000"
    }
    let scanner = Scanner(string:colorCode)
    var color:UInt32 = 0;
    scanner.scanHexInt32(&color)
    let mask = 0x000000FF
    let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
    let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
    let b = CGFloat(Float(Int(color) & mask)/255.0)
    let colorBrightness = ((r * 299) + (g * 587) + (b * 114)) / 1000;
    if (colorBrightness < 0.5)
    {
      defaults.set("#FFFFFF", forKey: "TextColor")
    }else{
      defaults.set("#000000", forKey: "TextColor")
    }
  }
  
  // ----------------------------------
  //  MARK: - Save Customer Token -
  //
  
  func saveCustomerToken(token:String,expiry:Date,email:String,password:String){
    let tokenInfo = ["token":token,"expiry":expiry,"email":email,"mageSPVal":password] as [String:Any]
    defaults.set(tokenInfo, forKey: "mageInfo")
    defaults.set(true, forKey: "mageShopLogin")
  }
  
  //----------------------------------
  //  MARK: - CheckForLogin
  //
  func isAppLogin()->Bool{
    return defaults.bool(forKey: "mageShopLogin")
  }
  
  //----------------------------------
  // MARK: - return the token
  //
  
  func getToken()->Any? {
    return defaults.value(forKey: "mageInfo")
  }
  
  //----------------------------------
  // MARK: - save the Currency
  //
  func saveCurrencyCode(currency:String){
    defaults.set(currency, forKey: "mageCurrencyCode")
  }
  
  
  //----------------------------------
  // MARK: - Get the Currency
  //
  func getCurrencyCode()->String?{
    return defaults.string(forKey:  "mageCurrencyCode")
  }
  
    //----------------------------------
    // MARK: - save the Country
    //
    func saveCountryCode(currency:String){
      defaults.set(currency, forKey: "mageCountryCode")
    }
    
    //----------------------------------
    // MARK: - Get the Country
    //
    func getCountryCode()->String?{
      return defaults.string(forKey:  "mageCountryCode")
    }
    
  //----------------------------------
  // MARK: - doLogout
  //
  
  func doLogOut()->Bool{
    defaults.removeObject(forKey: "mageInfo")
    defaults.set(false, forKey: "mageShopLogin")
    defaults.removeObject(forKey: "wholeSaleCustomerTags")
    defaults.removeObject(forKey: "growaveUserId")
    return true
  }
  
  // ----------------------------------
  //  MARK: - Get Storefront CurrencyCode using currency code -
  //
  
  func getStoreCurrencyCode()->MobileBuySDK.Storefront.CurrencyCode{
    var presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.usd
    if let currency = UserDefaults.standard.value(forKey: "mageCurrencyCode") as? String {
      switch currency.lowercased() {
      /// United Arab Emirates Dirham (AED).
      case "AED".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.aed
        
      /// Afghan Afghani (AFN).
      case "AFN".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.afn
        
      /// Albanian Lek (ALL).
      case "ALL".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.all
        
      /// Armenian Dram (AMD).
      case "AMD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.amd
        
      /// Netherlands Antillean Guilder.
      case "ANG".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.ang
        
      /// Angolan Kwanza (AOA).
      case "AOA".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.aoa
        
      /// Argentine Pesos (ARS).
      case "ARS".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.ars
        
      /// Australian Dollars (AUD).
      case "AUD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.aud
        
      /// Aruban Florin (AWG).
      case "AWG".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.awg
        
      /// Azerbaijani Manat (AZN).
      case "AZN".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.azn
        
      /// Bosnia and Herzegovina Convertible Mark (BAM).
      case "BAM".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.bam
        
      /// Barbadian Dollar (BBD).
      case "BBD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.bbd
        
      /// Bangladesh Taka (BDT).
      case "BDT".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.bdt
        
      /// Bulgarian Lev (BGN).
      case "BGN".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.bgn
        
      /// Bahraini Dinar (BHD).
      case "BHD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.bhd
        
      /// Burundian Franc (BIF).
      case "BIF".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.bif
        
      /// Bermudian Dollar (BMD).
      case "BMD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.bmd
        
      /// Brunei Dollar (BND).
      case "BND".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.bnd
        
      /// Bolivian Boliviano (BOB).
      case "BOB".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.bob
        
      /// Brazilian Real (BRL).
      case "BRL".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.brl
        
      /// Bahamian Dollar (BSD).
      case "BSD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.bsd
        
      /// Bhutanese Ngultrum (BTN).
      case "BTN".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.btn
        
      /// Botswana Pula (BWP).
      case "BWP".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.bwp
        
        
        
      /// Belize Dollar (BZD).
      case "BZD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.bzd
        
      /// Canadian Dollars (CAD).
      case "CAD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.cad
      /// Congolese franc (CDF).
      case "CDF".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.cdf
        
      /// Swiss Francs (CHF).
      case "CHF".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.chf
        
      /// Chilean Peso (CLP).
      case "CLP".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.clp
        
      /// Chinese Yuan Renminbi (CNY).
      case "CNY".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.cny
      /// Colombian Peso (COP).
      case "COP".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.cop
        
      /// Costa Rican Colones (CRC).
      case "CRC".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.crc
        
      /// Cape Verdean escudo (CVE).
      case "CVE".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.cve
        
      /// Czech Koruny (CZK).
      case "CZK".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.czk
        
      /// Djiboutian Franc (DJF).
      case "DJF".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.djf
        
      /// Danish Kroner (DKK).
      case "DKK".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.dkk
        
      /// Dominican Peso (DOP).
      case "DOP".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.dop
        
      /// Algerian Dinar (DZD).
      case "DZD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.dzd
        
      /// Egyptian Pound (EGP).
      case "EGP".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.egp
        
      /// Ethiopian Birr (ETB).
      case "ETB".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.etb
        
      /// Euro (EUR).
      case "EUR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.eur
        
      /// Fijian Dollars (FJD).
      case "FJD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.fjd
        
      /// Falkland Islands Pounds (FKP).
      case "FKP".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.fkp
        
      /// United Kingdom Pounds (GBP).
      case "GBP".lowercased():
        
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.gbp
        
      /// Georgian Lari (GEL).
      case "GEL".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.gel
        
      /// Ghanaian Cedi (GHS).
      case "GHS".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.ghs
        
      /// Gibraltar Pounds (GIP).
      case "GIP".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.gip
        
      /// Gambian Dalasi (GMD).
      case "GMD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.gmd
        
      /// Guinean Franc (GNF).
      case "GNF".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.gnf
        
      /// Guatemalan Quetzal (GTQ).
      case "GTQ".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.gtq
        
      /// Guyanese Dollar (GYD).
      case "GYD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.gyd
        
      /// Hong Kong Dollars (HKD).
      case "HKD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.hkd
        
      /// Honduran Lempira (HNL).
      case "HNL".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.hnl
        
      /// Croatian Kuna (HRK).
      case "HRK".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.hrk
        
      /// Haitian Gourde (HTG).
      case "HTG".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.htg
        
      /// Hungarian Forint (HUF).
      case "HUF".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.huf
        
      /// Indonesian Rupiah (IDR).
      case "IDR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.idr
        
      /// Israeli New Shekel (NIS).
      case "ILS".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.ils
        
      /// Indian Rupees (INR).
      case "INR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.inr
        
      /// Iraqi Dinar (IQD).
      case "IQD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.iqd
        
      /// Iranian Rial (IRR).
      case "IRR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.irr
        
      /// Icelandic Kronur (ISK).
      case "ISK".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.isk
        
      /// Jersey Pound.
      case "JEP".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.jep
        
      /// Jamaican Dollars (JMD).
      case "JMD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.jmd
        
      /// Jordanian Dinar (JOD).
      case "JOD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.jod
        
      /// Japanese Yen (JPY).
      case "JPY".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.jpy
        
      /// Kenyan Shilling (KES).
      case "KES".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.kes
        
      /// Kyrgyzstani Som (KGS).
      case "KGS".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.kgs
        
      /// Cambodian Riel.
      case "KHR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.khr
        
      /// Comorian Franc (KMF).
      case "KMF".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.kmf
        
      /// South Korean Won (KRW).
      case "KRW".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.krw
        
      /// Kuwaiti Dinar (KWD).
      case "KWD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.kwd
        
      /// Cayman Dollars (KYD).
      case "KYD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.kyd
        
      /// Kazakhstani Tenge (KZT).
      case "KZT".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.kzt
        
      /// Laotian Kip (LAK).
      case "LAK".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.lak
        
      /// Lebanese Pounds (LBP).
      case "LBP".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.lbp
        
      /// Sri Lankan Rupees (LKR).
      case "LKR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.lkr
        
      /// Liberian Dollar (LRD).
      case "LRD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.lrd
        
      /// Lesotho Loti (LSL).
      case "LSL".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.lsl
        
      /// Lithuanian Litai (LTL).
      case "LTL".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.ltl
        
      /// Latvian Lati (LVL).
      case "LVL".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.lvl
        
      /// Libyan Dinar (LYD).
      case "LYD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.lyd
        
      /// Moroccan Dirham.
      case "MAD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.mad
        
      /// Moldovan Leu (MDL).
      case "MDL".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.mdl
        
      /// Malagasy Ariary (MGA).
      case "MGA".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.mga
        
      /// Macedonia Denar (MKD).
      case "MKD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.mkd
        
      /// Burmese Kyat (MMK).
      case "MMK".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.mmk
        
      /// Mongolian Tugrik.
      case "MNT".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.mnt
        
      /// Macanese Pataca (MOP).
      case "MOP".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.mop
        
      /// Mauritian Rupee (MUR).
      case "MUR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.mur
        
      /// Maldivian Rufiyaa (MVR).
      case "MVR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.mvr
        
      /// Malawian Kwacha (MWK).
      case "MWK".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.mwk
        
      /// Mexican Pesos (MXN).
      case "MXN".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.mxn
        
      /// Malaysian Ringgits (MYR).
      case "MYR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.myr
        
      /// Mozambican Metical.
      case "MZN".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.mzn
        
      /// Namibian Dollar.
      case "NAD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.nad
        
      /// Nigerian Naira (NGN).
      case "NGN".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.ngn
        
      /// Nicaraguan Córdoba (NIO).
      case "NIO".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.nio
        
      /// Norwegian Kroner (NOK).
      case "NOK".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.nok
        
      /// Nepalese Rupee (NPR).
      case "NPR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.npr
        
      /// New Zealand Dollars (NZD).
      case "NZD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.nzd
        
      /// Omani Rial (OMR).
      case "OMR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.omr
        
      /// Panamian Balboa (PAB).
      case "PAB".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.pab
        
      /// Peruvian Nuevo Sol (PEN).
      case "PEN".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.pen
        
      /// Papua New Guinean Kina (PGK).
      case "PGK".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.pgk
        
      /// Philippine Peso (PHP).
      case "PHP".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.php
        
      /// Pakistani Rupee (PKR).
      case "PKR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.pkr
        
      /// Polish Zlotych (PLN).
      case "PLN".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.pln
        
      /// Paraguayan Guarani (PYG).
      case "PYG".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.pyg
        
      /// Qatari Rial (QAR).
      case "QAR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.qar
        
      /// Romanian Lei (RON).
      case "RON".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.ron
        
      /// Serbian dinar (RSD).
      case "RSD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.rsd
        
      /// Russian Rubles (RUB).
      case "RUB".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.rub
        
      /// Rwandan Franc (RWF).
      case "RWF".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.rwf
        
      /// Saudi Riyal (SAR).
      case "SAR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.sar
        
      /// Solomon Islands Dollar (SBD).
      case "SBD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.sbd
        
      /// Seychellois Rupee (SCR).
      case "SCR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.scr
        
      /// Sudanese Pound (SDG).
      case "SDG".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.sdg
        
      /// Swedish Kronor (SEK).
      case "SEK".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.sek
        
      /// Singapore Dollars (SGD).
      case "SGD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.sgd
        
      /// Saint Helena Pounds (SHP).
      case "SHP".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.shp
        
      /// Sierra Leonean Leone (SLL).
      case "SLL".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.sll
        
      /// Surinamese Dollar (SRD).
      case "SRD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.srd
        
      /// South Sudanese Pound (SSP).
      case "SSP".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.ssp
        
      /// Sao Tome And Principe Dobra (STD).
      case "STD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.stn
        
      /// Syrian Pound (SYP).
      case "SYP".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.syp
        
      /// Swazi Lilangeni (SZL).
      case "SZL".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.szl
        
      /// Thai baht (THB).
      case "THB".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.thb
        
      /// Tajikistani Somoni (TJS).
      case "TJS".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.tjs
        
      /// Turkmenistani Manat (TMT).
      case "TMT".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.tmt
        
      /// Tunisian Dinar (TND).
      case "TND".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.tnd
        
      /// Tongan Pa'anga (TOP).
      case "TOP".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.top
        
      /// Turkish Lira (TRY).
      case "TRY".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.try
        
      /// Trinidad and Tobago Dollars (TTD).
      case "TTD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.ttd
        
      /// Taiwan Dollars (TWD).
      case "TWD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.twd
        
      /// Tanzanian Shilling (TZS).
      case "TZS".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.tzs
        
      /// Ukrainian Hryvnia (UAH).
      case "UAH".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.uah
        
      /// Ugandan Shilling (UGX).
      case "UGX":
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.ugx
        
      /// United States Dollars (USD).
      case "USD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.usd
        
      /// Uruguayan Pesos (UYU).
      case "UYU".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.uyu
        
      /// Uzbekistan som (UZS).
      case "UZS".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.uzs
        
      /// Venezuelan Bolivares (VEF).
      case "VEF".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.ves
        
      /// Vietnamese đồng (VND).
      case "VND".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.vnd
        
      /// Vanuatu Vatu (VUV).
      case "VUV".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.vuv
        
      /// Samoan Tala (WST).
      case "WST".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.wst
        
      /// Central African CFA Franc (XAF).
      case "XAF".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.xaf
        
      /// East Caribbean Dollar (XCD).
      case "XCD".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.xcd
        
      /// West African CFA franc (XOF).
      case "XOF".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.xof
        
      /// CFP Franc (XPF).
      case "XPF".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.xpf
        
      /// Yemeni Rial (YER).
      case "YER".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.yer
        
      /// South African Rand (ZAR).
      case "ZAR".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.zar
        
      /// Zambian Kwacha (ZMW).
      case "ZMW".lowercased():
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.zmw
        
      default:
        presentmentCurrency = MobileBuySDK.Storefront.CurrencyCode.usd
      }
      
    }
    return presentmentCurrency
  }
  
  // --------------------------------
  //  MARK: - Refresh token
  //
  func refreshToken(){
    
    if(isAppLogin()){
      print("--currentdate--",Date())
      let tokenArray = getToken() as! [String:Any]
      let token = tokenArray["token"] as! String
      let usernameText = tokenArray["email"] as! String
      let password = tokenArray["mageSPVal"] as! String
      let expiry = tokenArray["expiry"] as! Date
      print("--expiry--",expiry)
      if(Date()<expiry){
        let mutation = ClientQuery.mutationForRenewToken(accessToken: token)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
          error.errorPrint()
          if let query =  response?.customerAccessTokenRenew {
            if let accessToken = query.customerAccessToken{
              Client.shared.saveCustomerToken(token: accessToken.accessToken, expiry: accessToken.expiresAt, email: usernameText, password: password)
            }
          }
        }
        task.resume()
      }
      else{
        Client.shared.customerAccessToken(email: usernameText, password: password, completion: {
          token,usererror,error in
          //self.view.stopLoader()
          UserDefaults.standard.set(password, forKey: "password")
          guard let token = token else {
            return
          }
          Client.shared.saveCustomerToken(token: token.accessToken, expiry: token.expireAt, email: usernameText, password: password)
        })
      }
    }
  }

  // ----------------------------------
  //  MARK: - ShopName -
  //
  @discardableResult
  func fetchShop(completion: @escaping (ShopViewModel?) -> Void) -> Task {
    
    let query = ClientQuery.queryForShop()
    let task  = self.client.queryGraphWith(query) { (query, error) in
      error.errorPrint()
      if let query = query {
        print("--fetch--")
        //print(query.shop)
        //print(query.articles)
        completion(query.shop.viewModel)
      } else {
        print("Failed to fetch shop name: \(String(describing: error))")
        completion(nil)
      }
    }
    
    task.resume()
    return task
  }
  
  // ----------------------------------
  //  MARK: - NavigationMenu -
  //
  @discardableResult
  func fetchNavigationMenu(completion: @escaping ([NavigationMenuItemViewModel]?) -> Void) -> Task {
    
    let query = ClientQuery.queryForNavigationMenu()
    let task  = self.client.queryGraphWith(query) { (query, error) in
      error.errorPrint()
      if let query = query {
        print("--fetch--")
        //print(query.shop)
        //print(query.articles)
        let items = query.menu?.items.viewModels
        completion(items)
      } else {
        print("Failed to fetch shop name: \(String(describing: error))")
        completion(nil)
      }
    }
    task.resume()
    return task
  }
  
  // ----------------------------------
  //  MARK: - Available Language -
  //
  @discardableResult
  func fetchAvailableLanguage(completion: @escaping ([String:String]?) -> Void) -> Task {
    
    let query = ClientQuery.queryForAvailableLanguage()
    let task  = self.client.queryGraphWith(query) { (query, error) in
      error.errorPrint()
      if let query = query {
        print("--fetch--")
        //print(query.shop)
        //print(query.articles)
        let val = [query.localization.language.name:query.localization.language.isoCode.rawValue]
        completion(val)
      } else {
        print("Failed to fetch shop name: \(String(describing: error))")
        completion(nil)
      }
    }
    task.resume()
    return task
  }
  //END

  // ----------------------------------
  //  MARK: - Fetch blogs -
  //
  
  @discardableResult
  func fetchShopBlog(completion: @escaping (PageableArray<BlogsViewModel>?) -> Void) -> Task {
    
    let query = ClientQuery.queryForShopBlog()
    let task  = self.client.queryGraphWith(query) { (query, error) in
      error.errorPrint()
      if let query = query {
        print("--fetch--")
        //print(query.shop)
          //print(query.blogs.edge)
        //completion(query.shop.viewModel)
          
          let blogs = PageableArray(
            with:     query.blogs.edges,
            pageInfo: query.blogs.pageInfo
          )
          completion(blogs)
      } else {
        print("Failed to fetch shop name: \(String(describing: error))")
        //completion(nil)
      }
    }
    task.resume()
    return task
  }
  
  // ----------------------------------
  //  MARK: - RecommendationProducts -
  //
  func fetchRecommendedProducts(query: [String:Any], completion: @escaping ([String:Any]?,Graph.QueryError?) -> Void) {
    var request = URLRequest(url: URL(string: "https://recommendations.loopclub.io/api/v1/recommendations/")!)
    request.httpMethod="POST"
    request.addValue(Client.shopUrl, forHTTPHeaderField: "X-SHOP")
    request.addValue("magenative", forHTTPHeaderField: "X-CLIENT")
    request.addValue("a2ds21R!3rT#R@R23r@#3f3ef", forHTTPHeaderField: "X-ACCESS-TOKEN")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    request.httpBody = try! JSONSerialization.data(withJSONObject: query)
    AF.request(request).responseData(completionHandler: {
      response in
      switch response.result {
      case .success:
        do {
          
          if  let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? [String:Any] {
            DispatchQueue.main.async {
              print("--json")
              print(json)
              completion(json,nil)
            }
          }
          else{
            completion(nil,nil)
          }
          
        }catch{
          print("catchedblock")
        }
      case .failure:
        print("failed")
      }
    })
    
  }
    // ----------------------------------
    //  MARK: - Get Payment Token -
    //
    func getPaymentToken(cardDetails : [String:String], checkout : CheckoutViewModel, shippingRate : ShippingRateViewModel,email : String, completion : @escaping(CheckoutViewModel?, [UserErrorViewModel]?)->Void)  {
        
        let cardClient: Card.Client = Card.Client()
              
              let creditCard = Card.CreditCard(
                  firstName:        cardDetails["firstName"] ?? "",
                  middleName:       cardDetails["middleName"] ?? "",
                  lastName:         cardDetails["lastName"] ?? "",
                  number:           cardDetails["cardNumber"] ?? "",
                  expiryMonth:      cardDetails["expiryMonth"] ?? "",
                  expiryYear:       cardDetails["expiryYear"] ?? "",
                  verificationCode: cardDetails["cvv"] ?? ""
              )
        
        Client.shared.fetchShop { shop in
            let url = shop?.cardVaultUrl
          //print("ShopCardVaultUrl==",shop?.cardVaultUrl)
            let countryCode = shop?.countryCode
            let shopName = shop?.shopName
            let task = cardClient.vault(creditCard, to: url!) { token, error in
                if error == nil {
                    Client.shared.updateCheckout(checkout.id, updatingEmail: email) { response in
                        let payCurrency = PayCurrency(currencyCode: checkout.currencyCode, countryCode: countryCode ?? "")
                        let payItems    = checkout.lineItems.map { item in
                          PayLineItem(price: item.individualPrice, quantity: item.quantity)
                        }
                        let moneyInput : MobileBuySDK.Storefront.MoneyInput = .init(amount: checkout.totalPrice, currencyCode: .init(rawValue: checkout.currencyCode)!)
                        
                        let paySession      = PaySession(shopName: shopName ?? "", checkout: checkout.payCheckout, currency: payCurrency, merchantID: Client.merchantID)
                        
                        let payment = MobileBuySDK.Storefront.CreditCardPaymentInputV2.create(
                            paymentAmount:  moneyInput,
                            idempotencyKey: paySession.identifier,
                            billingAddress: MobileBuySDK.Storefront.MailingAddressInput.create(address1: .init(orNull: response?.shippingAddress?.address1), address2: .init(orNull: response?.shippingAddress?.address2), city: .init(orNull: response?.shippingAddress?.city), country: .init(orNull: response?.shippingAddress?.country), firstName: .init(orNull: response?.shippingAddress?.firstName), lastName: .init(orNull: checkout.shippingAddress?.lastName), phone: .init(orNull: response?.shippingAddress?.phone), province: .init(orNull: response?.shippingAddress?.province), zip: .init(orNull: response?.shippingAddress?.zip)),
                            vaultId:        token!
                        )
                    
                        
                        let retry = Graph.RetryHandler<MobileBuySDK.Storefront.Mutation>(endurance : .finite(10)) { (response,error) -> Bool in
                            print(error.errorPrint())
                            if let response = response {
                                if response.checkoutCompleteWithCreditCardV2?.checkoutUserErrors.viewModels.count ?? 0 > 0 {
                                    return false
                                }
                                return response.checkoutCompleteWithCreditCardV2?.checkout?.ready ?? false == false
                            }
                            else {
                                return false
                            }
                        }

                        let mutation = ClientQuery.checkoutCompleteWithCreditCardV2(checkoutId: GraphQL.ID(rawValue: checkout.id)!, payment: payment)
                        let task1  = self.client.mutateGraphWith(mutation, retryHandler: retry) { response, error in
                            completion(response?.checkoutCompleteWithCreditCardV2?.checkout?.viewModel, response?.checkoutCompleteWithCreditCardV2?.checkoutUserErrors.viewModels)
                        }
                        task1.resume()
                    }
                }
            }
            task.resume()
        }
        
    }
  
    // ----------------------------------
    //  MARK: - First Sale Order -
    //
    func checkForFirstSaleDiscount(query: [String:String], completion: @escaping (JSON?,String?) -> Void) {
        
        
//    https://devshop.magenative.com/shopifymobilenew/shopifyapi/getrecords - Dev environment URL
//    https://shopmobileapp.cedcommerce.com/shopifymobilenew/shopifyapi/getrecords - Live environment URL
        guard let urlString = ("https://shopmobileapp.cedcommerce.com/shopifymobilenew/shopifyapi/getrecords" + "?" + encodeParamaters(params: query)).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else{
            return
        }
        
        let uri = URL(string: urlString)
        var request = URLRequest(url: uri!)
        request.httpMethod="POST"
         
      AF.request(request).responseData(completionHandler: {
        response in
        switch response.result {
        case .success:
          do {
              if let json = try? JSON(data: response.data!){
                  DispatchQueue.main.async {
                    print("--json")
                    print(json)
                      completion(json,nil)
                  }
              }
            else{
              completion(nil,nil)
            }
            
          }
        case .failure:
          completion(nil,"failed")
        }
      })
      
    }
  
  // ----------------------------------
  //  MARK: - ShopAllProducts -
  //
  @discardableResult
    func fetchShopAllProducts(limit: Int = 25, after cursor: String? = nil,with sortKey:MobileBuySDK.Storefront.ProductSortKeys? = nil,reverse:Bool?=nil,completion: @escaping (PageableArray<ProductListViewModel>?) -> Void) -> Task {
    
    let query = ClientQuery.queryForAllShopProducts(with: sortKey,reverse: reverse, limit: limit,after: cursor)
    let task  = self.client.queryGraphWith(query) { (query, error) in
      error.errorPrint()
      if let query = query {
        
        if customAppSettings.sharedInstance.outOfStocklabel {
          let products = PageableArray(
            with:     query.products.edges,
            pageInfo: query.products.pageInfo
          )
          completion(products)
        }
        else {
          let products = PageableArray(
            with:     query.products.edges.filter{$0.node.availableForSale},
            pageInfo: query.products.pageInfo
          )
          completion(products)
        }
        
      } else {
        print("Failed to fetch shop name: \(String(describing: error))")
        completion(nil)
      }
    }
    
    task.resume()
    return task
  }
  
  
  
  //-----------------------------------
  // MARK:- CustomerAssociate
  //
  @discardableResult
  func checkoutCustomerAssociateV2(checkoutId: GraphQL.ID, token: String, completion: @escaping (CheckoutViewModel?,Graph.QueryError?) -> Void)->Task{
    let mutation = ClientQuery.checkoutCustomerAssociateV2(checkoutId: checkoutId, token: token)
    let task     = self.client.mutateGraphWith(mutation) { response, error in
      error.errorPrint()
      if let query =  response?.checkoutCustomerAssociateV2 {
        print("check")
        completion(query.checkout?.viewModel,error)
      }else {
        completion(nil,error)
      }
    }
    task.resume()
    return task
  }
  
  // ----------------------------------
  //  MARK: - Collections -
  //
  @discardableResult
  func fetchCollections(limit: Int = 25, after cursor: String? = nil, productLimit: Int = 25, productCursor: String? = nil,maxImageWidth:Int32,maxImageHeight:Int32, completion: @escaping (PageableArray<CollectionViewModel>?,Graph.QueryError?) -> Void) -> Task {
    
    let query = ClientQuery.queryForCollections(limit: limit, after: cursor, productLimit: productLimit, productCursor: productCursor, maxHeight: maxImageHeight, maxWidth: maxImageWidth)
    let task  = self.client.queryGraphWith(query) { (query, error) in
      error.errorPrint()
      
      if let query = query {
        let collections = PageableArray(
          with:     query.collections.edges,
          pageInfo: query.collections.pageInfo
        )
        completion(collections,error)
      } else {
        print("Failed to load collections: \(String(describing: error))")
        completion(nil,error)
      }
    }
    
    task.resume()
    return task
  }
  
  
  // ----------------------------------
  //  MARK: - Products -
  //
/*  @discardableResult
  func fetchProducts(in collection: CollectionViewModel? = nil ,coll:collection? = nil,sortKey:MobileBuySDK.Storefront.ProductCollectionSortKeys? = nil,reverse:Bool? = nil, limit: Int = 15, after cursor: String? = nil, completion: @escaping (PageableArray<ProductListViewModel>?,URL?,Graph.QueryError?) -> Void) -> Task {
    
    let query = ClientQuery.queryForProducts(in: collection, coll: coll,with: sortKey,reverse: reverse, limit: limit, after: cursor)
    let task  = self.client.queryGraphWith(query) { (query, error) in
      error.errorPrint()
      if let query = query,
         let collection = query.node as? MobileBuySDK.Storefront.Collection {
        if customAppSettings.sharedInstance.outOfStocklabel {
          let products = PageableArray(
            with:     collection.products.edges,
            pageInfo: collection.products.pageInfo
          )
          completion(products,collection.image?.transformedSrc,error)
        }
        else {
          let products = PageableArray(
            with:     collection.products.edges.filter{$0.node.availableForSale},
            pageInfo: collection.products.pageInfo
          )
          completion(products,collection.image?.transformedSrc,error)
        }
      }
      else {
        print("Failed to load products in collection (\(String(describing: collection?.model?.node.id.rawValue))): \(String(describing: error))")
        completion(nil,nil,error)
      }
    }
    task.resume()
    return task
  }  */
    // ----------------------------------
    //  MARK: - Fetch Available Filters -
    //
    @discardableResult
    func fetchAvailableFilters(handle: String, completion: @escaping ([AvailableFilterViewModel]?,Graph.QueryError?) -> Void) -> Task {
        let query = ClientQuery.queryForFetchFilters(handle: handle)
          let task  = self.client.queryGraphWith(query) { (query, error) in
            error.errorPrint()
            if let query = query,
               let collection = query.collection {
                print("---filter---")
                print(query)
                completion(collection.products.filters.viewModels,error)
            }
            else {
              print("Failed to load filters: \(String(describing: error))")
              completion(nil,error)
            }
          }
        task.resume()
        return task
    }
    
    // ----------------------------------
    //  MARK: - Fetch Filtered Products -
    //
    @discardableResult
    func fetchFilteredProducts(handle: String? = nil ,coll:collection? = nil,sortKey:MobileBuySDK.Storefront.ProductCollectionSortKeys? = nil,reverse:Bool? = nil, limit: Int = 15, after cursor: String? = nil, filter: [MobileBuySDK.Storefront.ProductFilter]? = nil, completion: @escaping (PageableArray<ProductListViewModel>?,URL?,Graph.QueryError?,String?) -> Void) -> Task {
      
      let query = ClientQuery.queryForFilteredProducts(handle: handle, coll: coll,with: sortKey,reverse: reverse, limit: limit, after: cursor, filter: filter)
        print("filter--")
        
        print(filter?.first)
        let task  = self.client.queryGraphWith(query) { (query, error) in
          error.errorPrint()
          if let query = query,
             let collection = query.collection {
            if customAppSettings.sharedInstance.outOfStocklabel {
                let handle = collection.handle
              let products = PageableArray(
                with:     collection.products.edges,
                pageInfo: collection.products.pageInfo
              )
              completion(products,collection.image?.url,error,handle)
            }
            else {
                let handle = collection.handle
              let products = PageableArray(
                with:     collection.products.edges.filter{$0.node.availableForSale},
                pageInfo: collection.products.pageInfo
              )
              completion(products,collection.image?.url,error,handle)
            }
          }
          else {
            print("Failed to load products in collection (\(String(describing: handle))): \(String(describing: error))")
            completion(nil,nil,error,nil)
          }
        }
      task.resume()
      return task
    }
    
    @discardableResult
    func fetchProducts(in collection: CollectionViewModel? = nil ,coll:collection? = nil,sortKey:MobileBuySDK.Storefront.ProductCollectionSortKeys? = nil,reverse:Bool? = nil, limit: Int = 15, after cursor: String? = nil, completion: @escaping (PageableArray<ProductListViewModel>?,URL?,Graph.QueryError?,[String:String]?) -> Void) -> Task {
      
      let query = ClientQuery.queryForProducts(in: collection, coll: coll,with: sortKey,reverse: reverse, limit: limit, after: cursor)
        let task  = self.client.queryGraphWith(query) { (query, error) in
          error.errorPrint()
          if let query = query,
             let collection = query.collection {
              print("----product---\(collection.products.edges)")
            if customAppSettings.sharedInstance.outOfStocklabel {
                let handle = ["handle":collection.handle,"title":collection.title]
                
              let products = PageableArray(
                with:     collection.products.edges,
                pageInfo: collection.products.pageInfo
              )
              completion(products,collection.image?.url,error,handle)
            }
            else {
                let handle = ["handle":collection.handle,"title":collection.title]
                let products = PageableArray(
                with:     collection.products.edges.filter{$0.node.availableForSale},
                pageInfo: collection.products.pageInfo
              )
              completion(products,collection.image?.url,error,handle)
            }
          }
          else {
            print("Failed to load products in collection (\(String(describing: collection?.model?.node.id.rawValue))): \(String(describing: error))")
            completion(nil,nil,error,nil)
          }
        }
      task.resume()
      return task
    }
  
  // ----------------------------------
  //  MARK: - Fetch multi products by their ids -
  //
   
  
  @discardableResult
  func fetchMultiProducts(ids: [GraphQL.ID], completion: @escaping (Array<ProductViewModel>?,Graph.QueryError?) -> Void) -> Task {
    let query = ClientQuery.queryForMultiProducts(of: ids)
      let idsArray = ids.map{$0.rawValue}
    let task  = self.client.queryGraphWith(query) { (query, error) in
      error.errorPrint()
      if let query = query {
        var productViewModels = Array<ProductViewModel>()
        do {
          // print("wow",query.nodes)
          for index in query.nodes{
            //print(query.nodes)
            if(index != nil){
              let node = index as! MobileBuySDK.Storefront.Product
              if customAppSettings.sharedInstance.outOfStocklabel {
                productViewModels.append(node.viewModel)
              }
              else {
                  if(node.viewModel.model?.availableForSale ?? false){
                    productViewModels.append(node.viewModel)
                }
              }
            }
          }
            print(ids)
            print(productViewModels)
            if(productViewModels.count>0){
                let model = productViewModels.sorted {(idsArray.firstIndex(of: $0.id)!) < (idsArray.firstIndex(of: $1.id)!)}
              completion(model,error)
            }
            else{
                completion(productViewModels,error)
            }
        }
      }else {
        completion(nil,error)
      }
    }
    task.resume()
    return task
  }
  
  // ----------------------------------
  //  MARK: - Fetch Recommended products For a product
  //
  
  @discardableResult
  func fetchRecommendedProducts(ids: GraphQL.ID, completion: @escaping (Array<ProductViewModel>?,Graph.QueryError?) -> Void) -> Task {
    let query = ClientQuery.queryForRecommendedProducts(of: ids)
    let task  = self.client.queryGraphWith(query) { (query, error) in
      error.errorPrint()
      if let query = query {
        var productViewModels = Array<ProductViewModel>()
        do {
          
          if query.productRecommendations != nil {
            for index in query.productRecommendations!.compactMap({$0}) {
                let node = index
                if customAppSettings.sharedInstance.outOfStocklabel {
                  productViewModels.append(node.viewModel)
                }
                else {
                  if(node.viewModel.model?.availableForSale ?? false){
                    productViewModels.append(node.viewModel)
                  }
                }
            }
          }
          completion(productViewModels,error)
        }
      }else {
        completion(nil,error)
      }
    }
    task.resume()
    return task
  }
  
  //-----------------------------------
  // MARK:- Apply CouponCode
  //
  @discardableResult
  func applyCouponCode(_ discountCode: String, to checkoutID: String, completion: @escaping (CheckoutViewModel?,[UserErrorViewModel]?) -> Void)->Task{
    let mutation = ClientQuery.mutationForApplyCopounCode(discountCode, to: checkoutID)
    let task     = self.client.mutateGraphWith(mutation) { response, error in
      error.errorPrint()
        print(response)
        completion(response?.checkoutDiscountCodeApplyV2?.checkout?.viewModel, response?.checkoutDiscountCodeApplyV2?.checkoutUserErrors.viewModels)
    }
    task.resume()
    return task
  }
  
  //-----------------------------------
  // MARK:- Remove CouponCode
  //
  @discardableResult
  func removeCouponCode(to checkoutID: String, completion: @escaping (CheckoutViewModel?,Graph.QueryError?) -> Void)->Task{
    let mutation = ClientQuery.mutationForRemoveCopounCode(to: checkoutID)
    let task     = self.client.mutateGraphWith(mutation) { response, error in
      error.errorPrint()
      if let query =  response?.checkoutDiscountCodeRemove {
        completion(query.checkout?.viewModel,error)
      }
      else {
        completion(nil,error)
      }
    }
    task.resume()
    return task
  }
  
  //-----------------------------------
  // MARK:- Apply GiftCardCode
  //
  @discardableResult
  func applyGiftCardCode(_ discountCode: [String], to checkoutID: String, completion: @escaping (CheckoutViewModel?,Graph.QueryError?) -> Void)->Task{
    let mutation = ClientQuery.mutationForApplyGiftCardCode(discountCode, to: checkoutID)
    
    let task     = self.client.mutateGraphWith(mutation) { response, error in
      error.errorPrint()
      if let query =  response?.checkoutGiftCardsAppend {
        //print(query.checkout)
        completion(query.checkout?.viewModel,error)
        
      }else {
        completion(nil,error)
      }
    }
    task.resume()
    return task
  }
  
  //-----------------------------------
  // MARK:- Remove GiftCardCode
  //
  @discardableResult
  func removeGiftCardCode(_ discountCode: GraphQL.ID, to checkoutID: String, completion: @escaping (CheckoutViewModel?,Graph.QueryError?) -> Void)->Task{
    let mutation = ClientQuery.mutationForRemoveGiftCardCode(discountCode, to: checkoutID)
    let task     = self.client.mutateGraphWith(mutation) { response, error in
      error.errorPrint()
      if let query =  response?.checkoutGiftCardRemoveV2 {
        completion(query.checkout?.viewModel,error)
        
      }else {
        completion(nil,error)
      }
      
      
    }
    task.resume()
    return task
  }
  
  
  // ----------------------------------
  //  MARK: - Checkout -
  //
    
    /*
  @discardableResult
  func createCheckout(with cartItems: [CartDetails], completion: @escaping (CheckoutViewModel?,[UserErrorViewModel]?) -> Void) -> Task {
    let mutation = ClientQuery.mutationForCreateCheckout(with: cartItems)
    let task     = self.client.mutateGraphWith(mutation) { response, error in
      error.errorPrint()
      //print(response?.checkoutCreate?.checkout)
      completion(response?.checkoutCreate?.checkout?.viewModel,response?.checkoutCreate?.checkoutUserErrors.viewModels)
    }
    task.resume()
    return task
  }  */
    @discardableResult
    func createCartCheckout(with cartItems : [CartDetail],custom : [MobileBuySDK.Storefront.AttributeInput]?=nil ,discountCode:String="" ,orderNote:String="",completion:@escaping(CartCheckoutViewModel?,[CartCheckoutUserErrors]?)->Void)->Task {
        let mutation = ClientQuery.mutationForCreateCart(with: cartItems,custom: custom,discountCode: discountCode,cartNote: orderNote)
        let task = self.client.mutateGraphWith(mutation) { response, error in
            error.errorPrint()
            completion(response?.cartCreate?.cart?.viewModel,response?.cartCreate?.userErrors.viewModels)
        }
        task.resume()
        return task
    }
    
    
    @discardableResult
    func createCheckout(with cartItems: [CartDetail],custom:[MobileBuySDK.Storefront.AttributeInput]? = nil,productInput:[MobileBuySDK.Storefront.AttributeInput]? = nil, completion: @escaping (CheckoutViewModel?,[UserErrorViewModel]?,String?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForCreateCheckout(with: cartItems, custom: custom,productInput: productInput)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.errorPrint()
            

            print("---checkout---\(response)")
            print("---error---\(JSON(error))")
            completion(response?.checkoutCreate?.checkout?.viewModel,response?.checkoutCreate?.checkoutUserErrors.viewModels,error.debugDescription)
        }
        task.resume()
        return task
    }
    
  
  // ----------------------------------
  //  MARK: - SIGNUP -
  //
  @discardableResult
  func createCustomer(with fname:String,lname:String,email:String,password:String,newsletter:Bool,completion:@escaping(CustomerViewModel?,[CustomerErrorViewModel]?,Graph.QueryError?)->Void)->Task{
    let mutation = ClientQuery.queryForSignUp(email: email, password: password, firstName: fname, lastName: lname, acceptsMarketing: newsletter)
    let task     = self.client.mutateGraphWith(mutation) { response, error in
      error.errorPrint()
      if let response =  response?.customerCreate {
        
        completion(response.customer?.viewModel,response.customerUserErrors.viewModels,error)
      }else {
        
        completion(nil,nil,error)
      }
    }
    
    
    task.resume()
    return task
  }
  
  
  // ----------------------------------
  //  MARK: - CustomerAccessToken -
  //
  @discardableResult
  func customerAccessToken(email:String,password:String,completion:@escaping(CustomerAccessTokenModel?,[CustomerErrorViewModel]?,Graph.QueryError?)->Void)->Task{
    let mutation=ClientQuery.queryForCustomerToken(email: email, password: password)
    let task = self.client.mutateGraphWith(mutation){response,error in
      error.errorPrint()
      if let checkout = response?.customerAccessTokenCreate {
        completion(checkout.customerAccessToken?.viewModel,checkout.customerUserErrors.viewModels,error)
      }else {
        completion(nil,nil,error)
      }
    }
    task.resume()
    return task
  }
  
  // ----------------------------------
  //  MARK: - ForgetPassword -
  //
  @discardableResult
  func forgetPassword(with email:String,completion:@escaping([CustomerErrorViewModel]?,Graph.QueryError?)->Void)->Task{
    let mutation = ClientQuery.mutationForForgetPassword(with: email)
    let task = self.client.mutateGraphWith(mutation){response,error in
      error.errorPrint()
      completion(response?.customerRecover?.customerUserErrors.viewModels,error)
      
    }
    task.resume()
    return task
  }
  
  // ----------------------------------
  //  MARK: - MyOrders -
  //
  @discardableResult
  func fetchCustomerOrders(limit: Int = 15, after cursor: String? = nil, completion: @escaping (PageableArray<OrderViewModel>?,Graph.QueryError?) -> Void) -> Task {
    let tokenArray = getToken() as! [String:Any]
    let accessToken = tokenArray["token"] as! String
    let query = ClientQuery.queryForOrders(of: accessToken, limit: limit, after: cursor)
    let task = self.client.queryGraphWith(query, completionHandler: {
      query,error    in
      error.errorPrint()
      
      if let query = query, let customer = query.customer  {
        let orders = PageableArray(
          with:     customer.orders.edges,
          pageInfo: customer.orders.pageInfo
        )
        completion(orders,error)
      } else {
        print("Failed to load collections: \(String(describing: error))")
        completion(nil,error)
      }
    })
    task.resume()
    return task
  }
  
  
  // ----------------------------------
  //  MARK: - MyAddresses -
  //
  @discardableResult
  func fetchCustomerAddresses(limit: Int = 15, after cursor: String? = nil, completion: @escaping (PageableArray<AddressesViewModel>?,Graph.QueryError?) -> Void) -> Task {
    let tokenArray = getToken() as! [String:Any]
    let accessToken = tokenArray["token"] as! String
    let query = ClientQuery.queryForAddress(accessToken: accessToken, limit: limit)
    self.client.cachePolicy = .networkOnly
    let task = self.client.queryGraphWith(query, completionHandler: {
      query,error    in
      error.errorPrint()
      
      if let query = query, let customer = query.customer  {
        let address = PageableArray(
          with:     customer.addresses.edges,
          pageInfo: customer.addresses.pageInfo
        )
        completion(address,error)
      } else {
        print("Failed to load collections: \(String(describing: error))")
        completion(nil,error)
      }
    })
    task.resume()
    return task
  }
  
  // ----------------------------------
  //MARK : - FetchCustomer Details
  //
  @discardableResult
  func fetchCustomerDetails(completeion: @escaping(CustomerViewModel?,Graph.QueryError?)->Void)->Task{
    let tokenArray = getToken() as! [String:Any]
    let token = tokenArray["token"] as! String
    
    let query = ClientQuery.queryForCustomer(accessToken: token)
    let task = self.client.queryGraphWith(query, completionHandler: {
      response,error in
      error.errorPrint()
      if let response = response {
        completeion(response.customer?.viewModel,error)
      }
      
    })
    task.resume()
    return task
  }
  
  //----------------------------------
  //Mark : - Search Products
  //
  @discardableResult
    func searchProductsForQuery(for search:String,ids: [String] = [],limit: Int = 15, after cursor: String? = nil,with sortKey:MobileBuySDK.Storefront.ProductSortKeys? = nil,reverse:Bool?=nil, completion: @escaping (PageableArray<ProductListViewModel>?,Graph.QueryError?) -> Void) -> Task
  {
    
    let query = ClientQuery.queryForSearchProducts(for: search, limit: limit, after: cursor, with: sortKey,reverse: reverse)
    let task  = self.client.queryGraphWith(query) { (query, error) in
      error.errorPrint()
      
      if let query = query  {
        print("--pageable--",query.products)
          var edge = query.products.edges;
          if(!ids.isEmpty){
              edge = query.products.edges.sorted {((ids.firstIndex(of: $0.node.id.rawValue.components(separatedBy: "/").last ?? "")!)) < ((ids.firstIndex(of: $1.node.id.rawValue.components(separatedBy: "/").last ?? "")!))}
          }
        if customAppSettings.sharedInstance.outOfStocklabel {
          let products = PageableArray(
            with:     edge,
            pageInfo: query.products.pageInfo
          )
          //print("testing-"+products.items[0].title)
          completion(products,error)
        }
        else {
          let products = PageableArray(
            with:     edge.filter{$0.node.availableForSale},
            pageInfo: query.products.pageInfo
          )
          //print("testing-"+products.items[0].title)
          completion(products,error)
        }
      }else {
        completion(nil,error)
      }
    }
    task.resume()
    return task
  }
    
  //----------------------------------
  //Mark : - Single product fetch
  //
  
  @discardableResult
  func fetchSingleProduct(of id:String,completion:@escaping(ProductViewModel?,Graph.QueryError?)->Void)->Task{
    let query = ClientQuery.queryForSingleProduct(of:GraphQL.ID(rawValue: id))
    let task  = self.client.queryGraphWith(query) { (query, error) in
      error.errorPrint()
      print("--product query--")
        print(query)
      if let query = query,let node = query.node as? MobileBuySDK.Storefront.Product {
        completion(node.viewModel,error)
        
      }else {
        completion(nil,error)
      }
      
    }
    task.resume()
    return task
  }
  
  
  //----------------------------------
  //Mark : - Add Address
  //
  @discardableResult
  func customerAddAddress(address:[String:String],completeion: @escaping(AddressViewModel?,[CustomerErrorViewModel]?)->Void)->Task{
    let tokenArray = getToken() as! [String:Any]
    let token = tokenArray["token"] as! String
    let mutation = ClientQuery.customerAddAddressQuery(accessToken: token, address: address)
    let task  = self.client.mutateGraphWith(mutation){ response, error in
      error.errorPrint()
      if let response = response {
        completeion(
          response.customerAddressCreate?.customerAddress?.viewModel,
          response.customerAddressCreate?.customerUserErrors.viewModels)
      }
      
    }
    task.resume()
    
    return task
  }
    
    
    @discardableResult
    func customerAddShippingAddress(address:[String:String],checkoutID : GraphQL.ID, completeion: @escaping(CheckoutViewModel?, [UserErrorViewModel]?)->Void)->Task{
        let retry = Graph.RetryHandler<MobileBuySDK.Storefront.Mutation>(endurance: .finite(30)) { response, error -> Bool in
          error.errorPrint()
          
          if let response = response {
              return response.checkoutShippingAddressUpdateV2?.checkout?.availableShippingRates?.ready ?? false == false
              //return (response.checkoutShippingAddressUpdateV2?.checkout).availableShippingRates?.ready ?? false == false
          } else {
            return false
          }
        }

        let mutation = ClientQuery.checkoutShippingAddressUpdateV2(address: address, checkoutID: checkoutID)
        let task = self.client.mutateGraphWith(mutation, retryHandler: retry) { response, error in
            error.errorPrint()
            if let response = response {
                completeion(response.checkoutShippingAddressUpdateV2?.checkout?.viewModel, response.checkoutShippingAddressUpdateV2?.checkoutUserErrors.viewModels)
            }
        }
        task.resume()
        return task
    }
    
    
    @discardableResult
    func checkoutShippingLineUpdate(checkoutID : GraphQL.ID, shippingRAteHandle : String, completeion : @escaping(CheckoutViewModel?, [UserErrorViewModel]?)->Void)->Task {
        let mutation = ClientQuery.checkoutShippingLineUpdate(checkoutID: checkoutID, shippingRateHandle: shippingRAteHandle)
        let task = self.client.mutateGraphWith(mutation) {response, error in
            error.errorPrint()
            if let response = response {
                completeion(response.checkoutShippingLineUpdate?.checkout?.viewModel, response.checkoutShippingLineUpdate?.checkoutUserErrors.viewModels)
            }
        }
        task.resume()
        return task
    }
    
  
  
  //----------------------------------
  //Mark : - Delete Address
  //
  @discardableResult
  func customerDeleteAddress(address:AddressesViewModel,completeion: @escaping(String?,[CustomerErrorViewModel]?,Graph.QueryError?)->Void)->Task{
    
    let tokenArray = getToken() as! [String:Any]
    let token = tokenArray["token"] as! String
    let mutation = ClientQuery.customerDeleteAddress(addressId: address.id, with: token)
    let task  = self.client.mutateGraphWith(mutation){ response, error in
      error.errorPrint()
      if let response = response {
        completeion(
          response.customerAddressDelete?.deletedCustomerAddressId,
          response.customerAddressDelete?.customerUserErrors.viewModels,error)
      }else {
        completeion(nil,nil,error)
      }
    }
    task.resume()
    
    return task
  }
    // ----------------------------------
    //  MARK: - Update Address -
    //
    
 /*   @discardableResult
    func customerUpdateAddress(address:AddressesViewModel,completeion: @escaping(AddressViewModel?,[CustomerErrorViewModel]?)->Void)->Task{
      
      let tokenArray = getToken() as! [String:Any]
      let token = tokenArray["token"] as! String
        let mutation = ClientQuery.customerUpdateAddress(accessToken: token, address: address)
        let task  = self.client.mutateGraphWith(mutation){ response, error in
          error.errorPrint()
          if let response = response {
            completeion(
              response.customerAddressCreate?.customerAddress?.viewModel,
              response.customerAddressCreate?.customerUserErrors.viewModels)
          }
          
        }
        task.resume()
      
      return task
    }  */
    
    @discardableResult
       func customerUpdateAddress(address:[String:String],addressId:GraphQL.ID,completeion: @escaping(AddressViewModel?,[UserErrorViewModel]?)->Void)->Task{
           let tokenArray = getToken() as! [String:Any]
           let token = tokenArray["token"] as! String
           let mutation = ClientQuery.customerUpdateAddressQuery(accessToken: token, addressId: addressId, address: address)
           let task  = self.client.mutateGraphWith(mutation){ response, error in
               error.errorPrint()
               if let response = response {
                   completeion(
                       response.customerAddressUpdate?.customerAddress?.viewModel,nil)
                     //  response.customerAddressUpdate?.customerUserErrors.viewModels)
               }
           }
           task.resume()
           return task
       }
  
  // ----------------------------------
  //  MARK: - UpdateUser -
  //
  @discardableResult
  func updateCustomer(with fname:String,lname:String,email:String,password:String,completion:@escaping(CustomerViewModel?,[CustomerErrorViewModel]?,Graph.QueryError?)->Void)->Task{
    let tokenArray = getToken() as! [String:Any]
    let token = tokenArray["token"] as! String
    let mutation = ClientQuery.customerUpdateDetails(accessToken: token, email: email, password: password, firstName: fname, lastName: lname)
    
    let task     = self.client.mutateGraphWith(mutation) { response, error in
      error.errorPrint()
      completion(response?.customerUpdate?.customer?.viewModel,response?.customerUpdate?.customerUserErrors.viewModels,error)
    }
    task.resume()
    return task
  }
  
  
  @discardableResult
  func updateCheckout(_ id: String, updatingPartialShippingAddress address: PayPostalAddress, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
    let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingPartialShippingAddress: address)
    let task     = self.client.mutateGraphWith(mutation) { response, error in
      error.errorPrint()
      
      if let checkout = response?.checkoutShippingAddressUpdateV2?.checkout,
         let _ = checkout.shippingAddress {
        completion(checkout.viewModel)
      } else {
        completion(nil)
      }
    }
    
    task.resume()
    return task
  }
  
  @discardableResult
  func updateCheckout(_ id: String, updatingCompleteShippingAddress address: PayAddress, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
    let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingCompleteShippingAddress: address)
    let task     = self.client.mutateGraphWith(mutation) { response, error in
      error.errorPrint()
      
      if let checkout = response?.checkoutShippingAddressUpdateV2?.checkout,
         let _ = checkout.shippingAddress {
        completion(checkout.viewModel)
      } else {
        completion(nil)
      }
    }
    
    task.resume()
    return task
  }
  
  @discardableResult
  func updateCheckout(_ id: String, updatingShippingRate shippingRate: PayShippingRate, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
    let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingShippingRate: shippingRate)
    let task     = self.client.mutateGraphWith(mutation) { response, error in
      error.errorPrint()
      if let checkout = response?.checkoutShippingLineUpdate?.checkout,
         let _ = checkout.shippingLine {
        completion(checkout.viewModel)
      } else {
        completion(nil)
      }
    }
    task.resume()
    return task
  }
  
  @discardableResult
  func updateCheckout(_ id: String, updatingEmail email: String, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
    let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingEmail: email)
    let task     = self.client.mutateGraphWith(mutation) { response, error in
      error.errorPrint()
      
      if let checkout = response?.checkoutEmailUpdateV2?.checkout,
         let _ = checkout.email {
        completion(checkout.viewModel)
      } else {
        completion(nil)
      }
    }
    
    task.resume()
    return task
  }
  
  @discardableResult
  func fetchShippingRatesForCheckout(_ id: String, completion: @escaping ((checkout: CheckoutViewModel, rates: [ShippingRateViewModel])?) -> Void) -> Task {
    
    let retry = Graph.RetryHandler<MobileBuySDK.Storefront.QueryRoot>(endurance: .finite(30)) { response, error -> Bool in
      error.errorPrint()
      
      if let response = response {
        return (response.node as! MobileBuySDK.Storefront.Checkout).availableShippingRates?.ready ?? false == false
      } else {
        return false
      }
    }
    
    let query = ClientQuery.queryShippingRatesForCheckout(id)
    let task  = self.client.queryGraphWith(query, retryHandler: retry) { response, error in
      error.errorPrint()
      
      if let response = response,
         let checkout = response.node as? MobileBuySDK.Storefront.Checkout {
        completion((checkout.viewModel, checkout.availableShippingRates!.shippingRates!.viewModels))
      } else {
        completion(nil)
      }
    }
    task.resume()
    return task
  }
  
  func completeCheckout(_ checkout: PayCheckout, billingAddress: PayAddress, applePayToken token: String, idempotencyToken: String, completion: @escaping (PaymentViewModel?,Graph.QueryError?) -> Void) {
    
    let mutation = ClientQuery.mutationForCompleteCheckoutUsingApplePay(checkout, billingAddress: billingAddress, token: token, idempotencyToken: idempotencyToken)
    let task     = self.client.mutateGraphWith(mutation) { response, error in
      error.errorPrint()
      
      if let payment = response?.checkoutCompleteWithTokenizedPaymentV3?.payment {
        
        print("Payment created, fetching status...")
        self.fetchCompletedPayment(payment.id.rawValue) { paymentViewModel,error  in
          completion(paymentViewModel,error)
        }
        
      } else {
        completion(nil,error)
      }
    }
    
    task.resume()
  }
  
  func fetchCompletedPayment(_ id: String, completion: @escaping (PaymentViewModel?,Graph.QueryError?) -> Void) {
    
    let retry = Graph.RetryHandler<MobileBuySDK.Storefront.QueryRoot>(endurance: .finite(30)) { response, error -> Bool in
      error.errorPrint()
      
      if let payment = response?.node as? MobileBuySDK.Storefront.Payment {
        print("Payment not ready yet, retrying...")
        return !payment.ready
      } else {
        return false
      }
    }
    
    let query = ClientQuery.queryForPayment(id)
    let task  = self.client.queryGraphWith(query, retryHandler: retry) { query, error in
      
      if let payment = query?.node as? MobileBuySDK.Storefront.Payment {
        completion(payment.viewModel,error)
      } else {
        completion(nil,error)
      }
    }
    
    task.resume()
  }
    
    
    
    func fetchCoupons(query: [String:String], completion: @escaping (CouponResponse?,String?) -> Void) {
      
        guard let urlString = ("https://devshop.magenative.com/index.php/shopifymobilenew/shopifyapi/coupons" + "?" + encodeParamaters(params: query)).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else{
            return
        }
        
        let uri = URL(string: urlString)
        var request = URLRequest(url: uri!)
        request.httpMethod="POST"
         
      AF.request(request).responseData(completionHandler: {
        response in
        switch response.result {
        case .success:
          do {
              if let data = response.data {
                  let couponeResponse  = try? JSONDecoder().decode(CouponResponse.self, from: data)
                  completion(couponeResponse,nil)
              }
          }
        case .failure:
          completion(nil,"failed")
        }
      })
      
    }
    func encodeParamaters(params : [String : Any]) -> String {
       
       var result = ""
       
       for key in params.keys {
           
           result.append(key+"=\(params[key] ?? "")&")
           
       }
       
       if !result.isEmpty {
           result.remove(at: result.index(before: result.endIndex))
       }
       
       return result
   }
  
    func fetchCompletedOrder(_ id: String, completion: @escaping (CompleteOrderViewModel?) -> Void) {
    
    let retry = Graph.RetryHandler<MobileBuySDK.Storefront.QueryRoot>(endurance: .finite(30)) { (response, error) -> Bool in
      return (response?.node as? MobileBuySDK.Storefront.Checkout)?.order == nil
    }
    
    let query = MobileBuySDK.Storefront.buildQuery(inContext: .init(country: Client.shared.getCurrencyCodeVal(),language: Client.shared.getLanguageCode())) { $0
      .node(id: GraphQL.ID(rawValue: id)) { $0
        .onCheckout { $0
        
          .order { $0
         /*   .processedAt()
            .id()
            .orderNumber()
            .totalPriceV2{$0
              .amount()
            }
            .currencyCode()  */
          .totalPrice{$0
            .amount()
          }
          .id()
          .orderNumber()
          .totalPrice{$0
            .amount()
          }
          .fulfillmentStatus()
          .financialStatus()
          .customerLocale()
          .customerUrl()
          .email()
          .statusUrl()
          .phone()
          .cancelReason()
          .canceledAt()
          .subtotalPrice{$0
            .amount()
          }
          .totalTax{$0
            .amount()
          }
          .totalShippingPrice{$0
            .amount()
          }
          .processedAt()
          .currencyCode()
          
          .shippingAddress{$0
            .fragmentForStandardMailAddress()
          }
          
          .totalRefunded { $0
            .amount()
          }
          
          .lineItems(first: 250) { $0
            .edges { $0
              .cursor()
              .node { $0
                .variant { $0
                  .id()
                  .price{$0
                    .amount()
                  }
                  .product{ $0
                    .id()
                  }
                  .title()
                  .image {
                    $0
                          .url()
                      //.originalSrc()
                      //.transformedSrc()
                  }
                }
                .currentQuantity()
                .title()
                .quantity()
              }
            }
            .pageInfo { $0
            .hasNextPage()
          }
            
          }
          
          }
          
          
        }
          
        
      }
    }
    
    let task  = self.client.queryGraphWith(query, retryHandler: retry) { response, error in
      error.errorPrint()
      let checkout = (response?.node as? MobileBuySDK.Storefront.Checkout)
        completion(checkout?.order?.viewModel)
       
        
      //print(checkout?.order?.serialize().description)
    }
    task.resume()
  }
  
}




// ----------------------------------
//  MARK: - GraphErrorPrint -
//
extension Optional where Wrapped == Graph.QueryError {
  
  func errorPrint() {
    switch self {
    case .some(let value):
      print("Graph.QueryError: \(value)")
      
    case .none:
      break
    }
  }
  
  func getMessage(){
    switch self {
    case .some(let value):
      print("Graph.QueryError: \(value)")
      
    case .none:
      break
    }
    
  }
    
    
  
}

