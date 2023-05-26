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

class SideMenuTableCell : UITableViewCell {
  
  @IBOutlet weak var rightImage: UIImageView!
  //  @IBOutlet private weak var detailsLabel: UILabel!
  @IBOutlet weak var customTitleButton: UIButton!
  @IBOutlet weak var bottomLine: UILabel!
  
  
  @IBOutlet weak var topLine: UILabel!
  
  
  var additionButtonActionBlock : ((SideMenuTableCell) -> Void)?;
    var menu : MenuObject!
  override func awakeFromNib() {
    selectedBackgroundView? = UIView()
    selectedBackgroundView?.backgroundColor = .clear
  }  
  
  func setup(from menu :MenuObject,level:Int) {
      customTitleButton.setTitle(menu.name, for: .normal)
      customTitleButton.setTitleColor(UIColor(light: UIColor(hexString: "#383838"), dark: UIColor.provideColor(type: .SideMenuController).textColor), for: .normal)
      customTitleButton.titleLabel!.font = mageFont.regularFont(size: 14.0)
    self.backgroundColor=UIColor.clear
      self.bottomLine.isHidden=true
      self.topLine.isHidden=true;
   
         if Client.locale == "ar" {
             customTitleButton.contentHorizontalAlignment = .right
           rightImage.image = rightImage.image?.imageFlippedForRightToLeftLayoutDirection()
         }
        else{
            customTitleButton.contentHorizontalAlignment = .left
        }
  }
}
