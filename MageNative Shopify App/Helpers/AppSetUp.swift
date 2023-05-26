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
import UIKit


final class AppSetUp {
  
  let shared = AppSetUp()
  
  static var baseUrl: String{
    switch Client.environment {
    case .devEnvironment,.devPreview:
      return "https://dev-mobileapp.cedcommerce.com/"
    default:
      return "https://shopifymobileapp.cedcommerce.com/"
    }
    //return "https://shopifymobileapp.cedcommerce.com/"
  }
  static let applePayEnable = false
  static let isDrawerEnabled = true
}



class AppConfigure {

 static let shared = AppConfigure()
    
    func checkThemeColor()-> UIColor{
        let themeColor = UIColor.AppTheme().toHexString().lowercased()
        let textColor  = UIColor.textColor().toHexString().lowercased()
        switch themeColor {
        case  "#ffffff", "#000000":
            switch textColor {
            case  "#ffffff", "#000000":
                return UIColor(light: .black,dark: .white)
            default:
                return UIColor.textColor()
            }
        default:
            return UIColor.AppTheme()
        }
    }
    
    
    
    
    
}






struct mageFont{
  static let regularsize :CGFloat = 16.0
  static let headingLabel :CGFloat  = 18.0
  static let smallLabel :CGFloat = 12.0
  static  let boldFont = "Poppins-Bold"
  static let lightFont = "Poppins-Regular"
  static let mediumFont = "Poppins-Medium"
  static let extraLight = "Poppins-Light"
  static let italicLightFont = "Montserrat-LightItalic"
  static let italicMediumFont = "Montserrat-MediumItalic"
  static let italicBoldFont = "Montserrat-BoldItalic"
  
  static func setFont(fontWeight: String, fontStyle: String, fontSize: CGFloat = smallLabel) -> UIFont{
    switch fontWeight {
    case "bold":
      if(fontStyle == "italic"){
          return UIFont(name: italicBoldFont, size: fontSize)!
      }
      else{
          return UIFont(name: boldFont, size: fontSize)!
        
      }
    case "light":
       return UIFont(name: extraLight, size: fontSize)!
    case "medium":
      if(fontStyle == "italic"){
          return UIFont(name: italicMediumFont, size: fontSize)!
      }
      else{
          return UIFont(name: mediumFont, size: fontSize)!
      }
    default:
      if(fontStyle == "italic"){
       
          return UIFont(name: italicLightFont, size: fontSize)!
      }
      else{
          return UIFont(name: lightFont, size: fontSize)!
      }
    }
  }
}

extension mageFont {
    static func regularFont(size : CGFloat) -> UIFont {
        return UIFont(name: lightFont, size: size) ?? UIFont.systemFont(ofSize: 14.0)
    }
    
    static func mediumFont(size : CGFloat) -> UIFont {
        return UIFont(name: mediumFont, size: size) ?? UIFont.systemFont(ofSize: 16.0)
    }
    
    
    static func boldFont(size : CGFloat) -> UIFont {
        return UIFont(name: boldFont, size: size) ?? UIFont.boldSystemFont(ofSize: 16.0)
    }
    
    static func lightFont(size : CGFloat) -> UIFont {
        return UIFont(name: extraLight, size: size) ?? UIFont.systemFont(ofSize: 12.0)
    }
}

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}

class VersionManager {

 static let shared = VersionManager()
  
    static var panelVersion: String = String();

    func getReference(_ type: RefernceForKey,_ ref: DatabaseReference?)-> DatabaseReference?{
        var reference       : DatabaseReference?
        let panelVersionRef = VersionManager.panelVersion.isEmpty ? ref : ref?.child(VersionManager.panelVersion)
        print("reference==",panelVersionRef?.description())
        switch type {
        case .homepage_component:
            let lang = Client.shared.getLanguageCode()
            if VersionManager.panelVersion.isEmpty{
                reference =   panelVersionRef?.child("homepage_component")
            }else{
                reference = panelVersionRef?.child("homepage_component").child("\(lang)")
            }
        case .splash:
            reference = panelVersionRef?.child("additional_info").child("splash")
        case .dark_mode:
            reference = panelVersionRef?.child("additional_info").child("dark_mode")
        case .appthemecolor:
            reference = panelVersionRef?.child("additional_info").child("appthemecolor")
        case .text_color:
            reference = panelVersionRef?.child("additional_info").child("text_color")
        case .login:
            reference = panelVersionRef?.child("additional_info").child("login")
        case .features:
            reference = panelVersionRef?.child("features")
        case .available_locale:
            reference = panelVersionRef?.child("available_locale")
        case .version:
            reference = ref?.child("version")
        case .maintenance_mode:
            reference = ref?.child("additional_info").child("maintenance_mode")
        case .default_locale:
            if VersionManager.panelVersion.isEmpty{
                reference =   panelVersionRef?.child("additional_info").child("locale")
            }else{
                reference = panelVersionRef?.child("default_locale")
            }
            
        }
        return reference
    }
  
    
    
}

enum RefernceForKey{
    case homepage_component
    case splash
    case dark_mode
    case appthemecolor
    case text_color
    case login
    case features
    case available_locale
    case version
    case default_locale
    case maintenance_mode
}


extension UILabel{
    public func discountStyle(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.AppTheme()
        self.font = mageFont.regularFont(size: 10)
        self.textColor = UIColor.textColor()
        self.textAlignment = .center
        self.isHidden = true
        self.clipsToBounds = true
        self.layer.cornerRadius = 3
   
    }
}
