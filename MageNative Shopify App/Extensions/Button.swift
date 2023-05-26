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
import MobileBuySDK
import AlgoliaSearchClient

class Button: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.makeButtonRound()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.makeButtonRound()
  }
  
  private func makeButtonRound() {
    self.layer.cornerRadius  = 5.0
    self.layer.masksToBounds = true
    let shopUrl = Client.shopUrl.replacingOccurrences(of: ".myshopify.com", with: "")
      let ref = BaseViewController.secondaryDb?.reference(withPath: shopUrl).child("v2").child("additional_info")
    ref?.child("appthemecolor").observe(.value, with: {
      snapshot in
      if let dataObject = snapshot.value as? String {
        UserDefaults.standard.set(dataObject, forKey: "color")
        Client.shared.setTextColor(val: dataObject)
        self.backgroundColor = UIColor(hexString: dataObject)
          self.setTitleColor(UIColor.textColor(), for: .normal)
          self.titleLabel?.font = mageFont.mediumFont(size: 15.0)
      
      }
    })
  }
}

extension UIButton {
  func ButtonTextDown(spacing: CGFloat) {
    if let image = self.imageView?.image {
        if Client.locale == "ar" {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: 0.0, bottom: -(imageSize.height), right: -imageSize.width)
            let labelString = NSString(string: self.titleLabel!.text!)
              let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: mageFont.regularFont(size: 12.0)])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: -titleSize.width, bottom: 0.0, right: 0.0)
        }
        else {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
              let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: mageFont.regularFont(size: 12.0)])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
  }
  
  public func btnView()
  {
    self.backgroundColor = UIColor.clear
    self.layer.borderColor = UIColor(light: .black, dark: UIColor.provideColor(type: .cartVc).tintColor).cgColor
    self.layer.borderWidth = 0.5
    self.layer.cornerRadius = 5.0
    self.setTitleColor(UIColor(light: .black, dark: UIColor.white), for: .normal)
    
  }
  
  public func selectedBtnView(){
    self.backgroundColor = UIColor.AppTheme()
    self.layer.borderColor = UIColor.AppTheme().cgColor
    self.layer.borderWidth = 0.5
    self.layer.cornerRadius = 5.0
    self.setTitleColor(UIColor.textColor(), for: .normal)
  }
  
}

extension UIButton {
    
    func setupFont(fontType:FontType,fontSize:CGFloat=12.0,image:String="") {
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.titleTextAttributesTransformer =
            UIConfigurationTextAttributesTransformer { incoming in
                // 1
                var outgoing = incoming
                // 2
                switch fontType {
                case .Regular :
                    outgoing.font = mageFont.regularFont(size: fontSize)
                case .Medium :
                    outgoing.font = mageFont.mediumFont(size: fontSize)
                case .Bold :
                    outgoing.font = mageFont.boldFont(size: fontSize)
                }
                
                // 3
                return outgoing
            }
            
            config.imagePadding = 8
            if image != "" {
                config.image = UIImage(named: image)
                config.imagePlacement = Client.locale == "ar" ? .leading : .trailing
                config.imagePadding = 8
            }
            self.configuration = config
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    public enum FontType
    {
        case Regular, Medium, Bold
    }
    
    func addBottomBorderWithColorOnButton( color: UIColor, width: CGFloat) {
        let lineView = UIView(frame: CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 2))
        lineView.backgroundColor = color
        self.addSubview(lineView)
       // self.layoutIfNeeded()
    }
    
   
    
}


//extension UIButton {
//   func leftTitleButton(buttonPositionX: Double, buttonPositionY: Double ,buttonWidth: Double, buttonHeight: Double, buttonTilte: String) {
//       let button = self
//       button.frame = CGRect(x: buttonPositionX, y: buttonPositionY, width: buttonWidth, height: buttonHeight)
//       button.setTitle(buttonTilte, for: .normal)
//       button.backgroundColor = .clear
//       button.setTitleColor(.black, for: .normal)
//       button.titleLabel?.font = mageFont.mediumFont(size: 15.0)
//       button.contentHorizontalAlignment = .left
//   }
//}
