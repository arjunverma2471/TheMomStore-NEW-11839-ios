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

import UIKit

extension String {
  
  func convertToHtml(font: String, size: CGFloat) -> NSAttributedString? {
    var style = ""
    style += "<style>* { "
    style += "font-family: \"\(font)\" !important;"
    style += "font-size: \(size) !important;"
    style += "}"
    style += "span,img{width:100%;}"
    style += "</style>"
    
    
    let styledHTML = self.trimmingCharacters(in: CharacterSet.newlines).replacingOccurrences(of: "//cdn", with: "https://cdn").appending(style)
    
    let htmlData   = styledHTML.data(using: .utf8)!
    
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
      NSAttributedString.DocumentReadingOptionKey.documentType      : NSAttributedString.DocumentType.html,
      NSAttributedString.DocumentReadingOptionKey.characterEncoding : String.Encoding.utf8.rawValue,
    ]
    
    return try? NSAttributedString(data: htmlData, options: options, documentAttributes: nil)
  }
  init?(htmlEncodedString: String) {
    guard let data = htmlEncodedString.data(using: .utf8) else {
      return nil
    }
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
      NSAttributedString.DocumentReadingOptionKey.documentType      : NSAttributedString.DocumentType.html,
      NSAttributedString.DocumentReadingOptionKey.characterEncoding : String.Encoding.utf8.rawValue,
    ]
    guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
      return nil
    }
    self.init(attributedString.string)
  }
  func appendStyle(font: String, size: CGFloat) -> String? {
    var style = ""
    style += "<style>* { "
    style += "font-family: \"\(font)\" !important;"
    style += "font-size: \(size) !important;"
    style += "width:100% !important;"
    // style += "padding:0;"
    style += "margin:0;"
    style += "}"
    
    style += "</style>"
    
    return  self.trimmingCharacters(in: CharacterSet.newlines).replacingOccurrences(of: "//cdn", with: "https://cdn").appending(style)
    
  }
  
  func base64decode() -> String{
    let vdata=Data(base64Encoded: self, options: Data.Base64DecodingOptions.init(rawValue: 0))
    let vid=String(data: vdata!, encoding: String.Encoding.utf8)
    let vDigit=vid?.components(separatedBy: "/")
    return (vDigit?.last)!
//      if let vdata=Data(base64Encoded: self, options: Data.Base64DecodingOptions.init(rawValue: 0)) {
//          if let vid = String(data: vdata, encoding: String.Encoding.utf8) {
//            let vDigit=vid.components(separatedBy: "/")
//              return vDigit.last ?? ""
//
//          }
//      }
//     return ""
  }
    
    func isValidUrl() -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with:self)
        return result
    }
}
