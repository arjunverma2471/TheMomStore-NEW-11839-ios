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

class MyOrdersCell: UITableViewCell {
  
  
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var outerView: UIView!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var viewOrder: UIButton!
  @IBOutlet weak var orderId: UILabel!
  @IBOutlet weak var reorderBtn: UIButton!
  @IBOutlet weak var amount: UILabel!
  @IBOutlet weak var orderDate: UILabel!
  @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var returnBtn: Button!
    

    @IBOutlet weak var trackButton: Button!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    // calenderButton.setImage(UIImage(named:"calendar"), for: UIControlState.normal)
    //calenderButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
    self.reorderBtn.layer.cornerRadius = 8.0
      headerView.backgroundColor = UIColor(light: .lightGray,dark: .black)
      self.reorderBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
      self.viewOrder.titleLabel?.font = mageFont.regularFont(size: 15.0)
      self.viewOrder.tintColor = UIColor(light: .AppTheme(), dark: .white)
      
      self.trackButton.layer.cornerRadius = 8.0
    if customAppSettings.sharedInstance.reorder == true {
      self.reorderBtn.isHidden=false
    }
    else {
      self.reorderBtn.isHidden=true
    }
  }
  
    func configureFrom(_ model:OrderViewModel) {
        orderId.text = "Order Number : ".localized+model.orderNumber
        orderNumber.text = "#\(model.orderNumber)"+" : "+"\(model.fulfillmentStatus)"
        orderDate.text = "Placed On : ".localized+model.processedAt
        amount.text = "Total Amount : ".localized+model.totalPrice
        name.text = "Bought For : ".localized+model.name
        orderId.font = mageFont.regularFont(size: 14.0)
        orderNumber.font = mageFont.regularFont(size: 14.0)
        orderDate.font = mageFont.regularFont(size: 14.0)
        amount.font = mageFont.regularFont(size: 14.0)
        name.font = mageFont.regularFont(size: 14.0)
        viewOrder.setTitle("Order Details".localized, for: .normal)
        reorderBtn.setTitle("REORDER".localized, for: .normal)
        returnBtn.setTitle("RETURN/EXCHANGE".localized, for: .normal)
        returnBtn.titleLabel?.font = mageFont.mediumFont(size: 14.0)
        
        trackButton.setTitle("TRACK ORDER".localized, for: .normal)
        trackButton.titleLabel?.font = mageFont.mediumFont(size: 13.0)
        trackButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
