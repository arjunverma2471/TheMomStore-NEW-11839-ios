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


final class OrderLineItemViewModel: ViewModel {
    
    typealias ModelType = MobileBuySDK.Storefront.OrderLineItemEdge
    
    let model:    ModelType?
    let cursor:   String
    
    let variantID:       String?
    let title:           String
    let quantity:        Int
    let individualPrice: Decimal
    let totalPrice:      Decimal
    let variantTitle : String
    let image:String
    
    // ----------------------------------
    //  MARK: - Init -
    //
  required init(from model: ModelType) {
    self.model           = model
    self.cursor          = model.cursor
    self.title           = model.node.title
    self.quantity        = Int(model.node.quantity)
    self.variantTitle = model.node.variant?.title ?? ""
    self.image = (model.node.variant?.image?.url.description ?? "")
    
    if model.node.variant == nil{
      self.variantID = ""
      self.individualPrice = 0.0
      self.totalPrice = 0.0
    }
    else
    {
      self.variantID = model.node.variant?.id.description
      self.individualPrice = model.node.variant!.price.amount
      self.totalPrice      = self.individualPrice * Decimal(self.quantity)
    }
  }
}

extension MobileBuySDK.Storefront.OrderLineItemEdge: ViewModeling {
    typealias ViewModelType = OrderLineItemViewModel
}
