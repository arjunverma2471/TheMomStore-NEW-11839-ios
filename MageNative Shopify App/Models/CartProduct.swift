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

class CartProduct:Equatable {
  
  private struct CartKey {
    static let product  = "product"
    static let quantity = "quantity"
    static let variant  = "variant"
    static let id = "id"
  }
  
  let productModel:ProductViewModel?
  let variant:VariantDetail
  let sellingPlanId : String
  var qty=1
  
    required init(product: ProductViewModel?, variant: VariantDetail, quantity: Int = 1, sellingPlanId : String = "") {
    self.productModel  = product
    self.variant  = variant
    self.qty = quantity
    self.sellingPlanId = sellingPlanId
  }
  
}

extension CartProduct{
    static func == (lhs: CartProduct, rhs: CartProduct) -> Bool {
        return (lhs.productModel!.id == rhs.productModel!.id) && (lhs.variant.id == rhs.variant.id)
    }
    
    static func === (lhs: WishlistDetail, rhs: CartProduct) -> Bool {
        return (lhs.id == rhs.productModel!.id) && (lhs.variant?.id == rhs.variant.id)
    }
    
}
