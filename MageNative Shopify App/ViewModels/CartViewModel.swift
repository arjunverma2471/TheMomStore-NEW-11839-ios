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

class CartViewModel{
   
    typealias ModelType = CartProduct
    let model : ModelType?
    let imageURL: URL?
    let title:    String
    let subtitle: String
    let price:    String
    let quantity: Int
    let id: String
    
    required init(from model: ModelType) {
        self.model = model
        self.imageURL = URL(string: model.variant.imageUrl)
        self.title = model.productModel?.title ?? ""
        self.subtitle = model.variant.title
        self.quantity = model.qty
        self.price = Currency.stringFrom(1 * Decimal(model.qty))
        self.id = model.productModel?.id ?? ""
    }
}
 /*
extension CartProduct: ViewModeling {
    typealias ViewModelType = CartViewModel
}
*/
