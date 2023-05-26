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
import CommonCrypto
import UIKit

extension String {
  func getURL()-> URL?{
    do {
      return try self.asURL()
    }catch {
      return nil
    }
  }
}


extension String {
  var localized: String {
    /*let lang = "en"
     //let path = Bundle.main.path(forResource: lang, ofType: "lproj");
     //let bundle = Bundle(path: path!);
     return NSLocalizedString(self, comment: "")*///NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "");
    
    if let path = Bundle.main.path(forResource: Client.locale, ofType: "lproj")
    {
      let bundle = Bundle(path: path);
      return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "");
    }
    else
    {
      
      return self;
    }
  }
  public func isValidEmail() -> Bool
  {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx);
    return emailTest.evaluate(with: self);
    
  }
  public func isValidName() -> Bool
  {
    let RegEx = "[a-zA-Z ]*$";
    let Test = NSPredicate(format:"SELF MATCHES %@", RegEx);
    return Test.evaluate(with: self);
    
  }
  
  public func isValidPhone() -> Bool {
          let phoneRegex = "^[0-9+]{0,1}+[0-9]{6,9}$"
          let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
      return phoneTest.evaluate(with: self.replacingOccurrences(of: " ", with: ""))
      }
  
  func allowedString() -> String {
    let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();|:@&=+$,/?%#[] ").inverted)
    
    if let escapedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
      return escapedString
    }
    return ""
  }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    

}

extension UIViewController {
    func generateRandom(size: UInt) -> String {
            let prefixSize = Int(min(size, 43))
            let uuidString = UUID().uuidString.replacingOccurrences(of: "-", with: "")
            return String(Data(uuidString.utf8)
                .base64EncodedString()
                .replacingOccurrences(of: "=", with: "")
                .prefix(prefixSize))
        }
}

extension String {
  var htmlToAttributedString: NSMutableAttributedString? {
    guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
    do {
      return try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
    } catch {
      return NSMutableAttributedString()
    }
  }
  var htmlToString: String {
    return htmlToAttributedString?.string ?? ""
  }
}

